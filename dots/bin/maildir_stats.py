import mailbox
import email
from email.parser import HeaderParser


def count_senders(messages):
    """Count occurrences of each sender in the given messages."""
    counters = {}
    for msg_id, msg in messages:
        from_header = str(msg.get("From"))
        if from_header not in counters:
            counters[from_header] = 1
        else:
            counters[from_header] = counters[from_header] + 1
    return counters


def sort_by_count(counters):
    """Return a dict sorted by count (ascending)."""
    return dict(sorted(counters.items(), key=lambda x: x[1]))


def total_count(counters):
    """Return the total number of messages across all senders."""
    return sum(counters.values())


if __name__ == "__main__":
    mb = mailbox.Maildir('/home/gs/mail/personal/Archive', create=False)
    mb.lock()

    counters = count_senders(mb.iteritems())
    sorted_counters = sort_by_count(counters)

    senders = sorted(counters.keys())
    for k in senders:
        print(k)

    acc = 0
    for k in sorted_counters:
        v = sorted_counters[k]
        acc += v
        print(f'{k} = {v}')

    print(total_count(counters))
    mb.unlock()
