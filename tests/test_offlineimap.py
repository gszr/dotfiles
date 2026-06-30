import sys
from unittest.mock import patch, MagicMock

import pytest

sys.path.insert(0, "dots")
import offlineimap


class TestGetPassword:
    @patch("offlineimap.subprocess.check_output")
    def test_calls_pass_with_correct_passname(self, mock_check_output):
        mock_check_output.return_value = b"secret123\n"

        result = offlineimap.get_password("personal")

        mock_check_output.assert_called_once_with(["pass", "personal/mail"])
        assert result == b"secret123"

    @patch("offlineimap.subprocess.check_output")
    def test_strips_trailing_whitespace(self, mock_check_output):
        mock_check_output.return_value = b"  mypassword  \n\n"

        result = offlineimap.get_password("work")

        assert result == b"mypassword"

    @patch("offlineimap.subprocess.check_output")
    def test_different_account_names(self, mock_check_output):
        mock_check_output.return_value = b"pw"

        offlineimap.get_password("work-corp")
        mock_check_output.assert_called_once_with(["pass", "work-corp/mail"])

    @patch("offlineimap.subprocess.check_output")
    def test_empty_password(self, mock_check_output):
        mock_check_output.return_value = b"\n"

        result = offlineimap.get_password("test")

        assert result == b""

    @patch("offlineimap.subprocess.check_output")
    def test_pass_command_failure(self, mock_check_output):
        mock_check_output.side_effect = FileNotFoundError("pass not found")

        with pytest.raises(FileNotFoundError):
            offlineimap.get_password("account")
