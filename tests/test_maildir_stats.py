import sys
from email.message import Message
from unittest.mock import MagicMock

import pytest

sys.path.insert(0, "dots/bin")
from maildir_stats import count_senders, sort_by_count, total_count


def _make_msg(from_header):
    """Create a minimal email Message with a From header."""
    msg = Message()
    msg["From"] = from_header
    return msg


class TestCountSenders:
    def test_single_sender(self):
        messages = [("1", _make_msg("alice@example.com"))]
        result = count_senders(messages)
        assert result == {"alice@example.com": 1}

    def test_multiple_messages_same_sender(self):
        messages = [
            ("1", _make_msg("alice@example.com")),
            ("2", _make_msg("alice@example.com")),
            ("3", _make_msg("alice@example.com")),
        ]
        result = count_senders(messages)
        assert result == {"alice@example.com": 3}

    def test_multiple_senders(self):
        messages = [
            ("1", _make_msg("alice@example.com")),
            ("2", _make_msg("bob@example.com")),
            ("3", _make_msg("alice@example.com")),
        ]
        result = count_senders(messages)
        assert result == {"alice@example.com": 2, "bob@example.com": 1}

    def test_empty_messages(self):
        result = count_senders([])
        assert result == {}

    def test_message_without_from_header(self):
        msg = Message()
        messages = [("1", msg)]
        result = count_senders(messages)
        assert result == {"None": 1}


class TestSortByCount:
    def test_sorts_ascending_by_count(self):
        counters = {"alice": 5, "bob": 1, "charlie": 3}
        result = sort_by_count(counters)
        keys = list(result.keys())
        assert keys == ["bob", "charlie", "alice"]

    def test_single_entry(self):
        counters = {"alice": 1}
        result = sort_by_count(counters)
        assert result == {"alice": 1}

    def test_empty_dict(self):
        result = sort_by_count({})
        assert result == {}

    def test_equal_counts_preserves_order(self):
        counters = {"alice": 2, "bob": 2}
        result = sort_by_count(counters)
        assert list(result.values()) == [2, 2]


class TestTotalCount:
    def test_sums_all_values(self):
        counters = {"alice": 5, "bob": 3, "charlie": 2}
        assert total_count(counters) == 10

    def test_single_sender(self):
        assert total_count({"alice": 7}) == 7

    def test_empty_dict(self):
        assert total_count({}) == 0
