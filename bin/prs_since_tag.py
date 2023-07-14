#!/bin/env python

import sys
import datetime
import textwrap
from git import Repo, Git
from github import Github

class escapes:
    GREEN = '\033[32m'
    BOLD = '\033[1m'
    END = '\033[0m'

def print_bold(s):
    print(escapes.BOLD + s + escapes.END)

def print_green(s):
    print(escapes.BOLD + escapes.GREEN + s + escapes.END)

def get_pulls(repo, token, base):
    g = Github(token)
    gh_repo = g.get_repo(repo)
    return gh_repo.get_pulls(state = 'closed', sort = 'updated', base = base, direction = 'desc')

def get_latest_common_ancestor(ref1, ref2, repo_path = "."):
    git_repo = Repo(repo_path)
    return git_repo.merge_base(ref1, ref2)[0]

def datetime_to_epoch(d):
    return (pr.updated_at - datetime.datetime(1970, 1, 1)).total_seconds()


if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("Usage: %s <origin_ref> <target_ref> <repo_dir> <github org/repo> [<github oauth2 token>]" % __file__)
        sys.exit()

    origin_ref = sys.argv[1]
    target_ref = sys.argv[2]
    repo_path = sys.argv[3]
    gh_repo = sys.argv[4]
    gh_token = sys.argv[5] if sys.argv == 6 else None

    latest_common_ancestor = get_latest_common_ancestor(origin_ref, target_ref,
                                                        repo_path = repo_path)
    latest_ancestor_epoch = latest_common_ancestor.committed_date

    print("Origin ref is '%s'" % origin_ref)
    print("Latest common ancestor between '%s' and '%s' is '%s'\n"
            % (origin_ref, target_ref, latest_common_ancestor))

    print("----\n")

    for pr in get_pulls(gh_repo, gh_token, target_ref):
        if datetime_to_epoch(pr.updated_at) > latest_ancestor_epoch:
            print_green("#%d - %s - %s" % (pr.number, pr.title, pr.updated_at))
            print("%s\n" % pr.url)
            if pr.body.strip():
                print("%s\n" % textwrap.fill(pr.body, initial_indent='  ', subsequent_indent='  '))
        else:
            break
