import datetime
import sys
from io import StringIO
from unittest.mock import MagicMock, patch

import pytest

sys.path.insert(0, "dots/bin")
import prs_since_tag


class TestEscapes:
    def test_green_escape(self):
        assert prs_since_tag.escapes.GREEN == '\033[32m'

    def test_bold_escape(self):
        assert prs_since_tag.escapes.BOLD == '\033[1m'

    def test_end_escape(self):
        assert prs_since_tag.escapes.END == '\033[0m'


class TestPrintBold:
    def test_wraps_text_in_bold(self, capsys):
        prs_since_tag.print_bold("hello")
        captured = capsys.readouterr()
        assert captured.out == '\033[1mhello\033[0m\n'

    def test_empty_string(self, capsys):
        prs_since_tag.print_bold("")
        captured = capsys.readouterr()
        assert captured.out == '\033[1m\033[0m\n'


class TestPrintGreen:
    def test_wraps_text_in_bold_green(self, capsys):
        prs_since_tag.print_green("success")
        captured = capsys.readouterr()
        assert captured.out == '\033[1m\033[32msuccess\033[0m\n'

    def test_empty_string(self, capsys):
        prs_since_tag.print_green("")
        captured = capsys.readouterr()
        assert captured.out == '\033[1m\033[32m\033[0m\n'


class TestGetPulls:
    @patch("prs_since_tag.Github")
    def test_calls_github_api_with_correct_params(self, mock_github_cls):
        mock_gh = MagicMock()
        mock_github_cls.return_value = mock_gh
        mock_repo = MagicMock()
        mock_gh.get_repo.return_value = mock_repo
        mock_repo.get_pulls.return_value = ["pr1", "pr2"]

        result = prs_since_tag.get_pulls("org/repo", "token123", "main")

        mock_github_cls.assert_called_once_with("token123")
        mock_gh.get_repo.assert_called_once_with("org/repo")
        mock_repo.get_pulls.assert_called_once_with(
            state='closed', sort='updated', base='main', direction='desc'
        )
        assert result == ["pr1", "pr2"]

    @patch("prs_since_tag.Github")
    def test_with_none_token(self, mock_github_cls):
        mock_gh = MagicMock()
        mock_github_cls.return_value = mock_gh
        mock_repo = MagicMock()
        mock_gh.get_repo.return_value = mock_repo

        prs_since_tag.get_pulls("org/repo", None, "develop")

        mock_github_cls.assert_called_once_with(None)
        mock_repo.get_pulls.assert_called_once_with(
            state='closed', sort='updated', base='develop', direction='desc'
        )


class TestGetLatestCommonAncestor:
    @patch("prs_since_tag.Repo")
    def test_returns_first_merge_base(self, mock_repo_cls):
        mock_repo = MagicMock()
        mock_repo_cls.return_value = mock_repo
        mock_commit = MagicMock()
        mock_repo.merge_base.return_value = [mock_commit]

        result = prs_since_tag.get_latest_common_ancestor("ref1", "ref2", "/path")

        mock_repo_cls.assert_called_once_with("/path")
        mock_repo.merge_base.assert_called_once_with("ref1", "ref2")
        assert result is mock_commit

    @patch("prs_since_tag.Repo")
    def test_default_repo_path(self, mock_repo_cls):
        mock_repo = MagicMock()
        mock_repo_cls.return_value = mock_repo
        mock_repo.merge_base.return_value = [MagicMock()]

        prs_since_tag.get_latest_common_ancestor("a", "b")

        mock_repo_cls.assert_called_once_with(".")


class TestDatetimeToEpoch:
    def test_converts_datetime_to_epoch(self):
        # datetime_to_epoch references a global `pr` variable (a bug in the original),
        # so we patch it to test the conversion logic
        mock_pr = MagicMock()
        mock_pr.updated_at = datetime.datetime(2020, 1, 1, 0, 0, 0)

        with patch.object(prs_since_tag, "pr", mock_pr, create=True):
            # The function uses pr.updated_at, not the argument d
            result = prs_since_tag.datetime_to_epoch(None)
            expected = (datetime.datetime(2020, 1, 1) - datetime.datetime(1970, 1, 1)).total_seconds()
            assert result == expected

    def test_epoch_zero(self):
        mock_pr = MagicMock()
        mock_pr.updated_at = datetime.datetime(1970, 1, 1, 0, 0, 0)

        with patch.object(prs_since_tag, "pr", mock_pr, create=True):
            result = prs_since_tag.datetime_to_epoch(None)
            assert result == 0.0
