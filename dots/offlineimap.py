import subprocess

def get_password(account):
    passname = "%s/mail" % account
    return subprocess.check_output(["pass", passname]).strip()

