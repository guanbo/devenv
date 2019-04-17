# Redmine

## Prepare

- buy your domain such as: `example.com`
- configure smtp server, such as: `smtp.exmail.qq.com`
- register eamil account `redmine@example.com` for send email
- s3 bucket `redmine.example.com` and subdirectory `backup` for backup

## Install

```sh
$ ./install.sh
```

## Gitlab Commit Messages

[Referencing-issues-in-commit-messages](http://www.redmine.org/projects/redmine/wiki/RedmineSettings#Referencing-issues-in-commit-messages)

```
This commit refs:#1, #2 and rm #3
This commit Refs  #1, #2 and rm #3
This commit REFS: #1, #2 and rm #3
```
