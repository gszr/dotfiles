import mailbox
import email
from email.parser import HeaderParser

mb = mailbox.Maildir('/home/gs/mail/personal/Archive', create=False)
mb.lock()

parser = HeaderParser()

counters = {}

for msg_id, msg in mb.iteritems():
    from_header = str(msg.get("From"))

    if from_header not in counters:
        counters[from_header] = 1
    else:
        counters[from_header] = counters[from_header] + 1

sorted_counters = dict(sorted(counters.items(), key=lambda x: x[1]))

senders = sorted(counters.keys())
for k in senders:
    print(k)

acc = 0
for k in sorted_counters:
    v = sorted_counters[k]
    acc += v
    print(f'{k} = {v}')

print(acc)
mb.unlock()
