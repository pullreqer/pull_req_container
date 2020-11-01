### About

These are some ramshackle scripts for building containers for a git server with the the [pull_req_githook](https://github.com/ratmice/pull_req_githook)
and a `git-shell` environment for ssh.

The containers a built and run rootless, and there is an excessive amount of caching between builds.

### Dependencies

[podman](https://github.com/containers/podman) and [buildah](https://github.com/containers/buildah)

you will also need https://git-repo.info

### Usage:
Build container with`./mk_pull_req_container`, run it using `build/gen_code/git_start.sh`
A systemd unit is in `build/gen_code/pullreqer.service` you can enable it with
```
mkdir -p ~/.config/systemd/user
cp build/gen_code/pullreqer.service ~/.config/systemd/user
systemctl --user enable pullreqer.service --now
```

Add the keys generated in `persistent/keys/user_key` to `~/.ssh/.config`,
and the public key is known to the container.

```
Host localhost
    HostName localhost 
    User yourusername
    Port 2222
    IdentityFile path/to/persistent/keys/user_key
```

```
ssh localhost create_pr_repo test
git clone ssh://${USER}@localhost:2222/~${USER}/test.git`
pushd .
echo "foo">foo.txt
git add foo.txt
git commit -m "there must be an initial commit"
git push
echo "bar">foo.txt
git add foo.txt
git commit -m "silly pull-request"
git pr
git fetch origin for/master/pr0:pr0
git checkout pr0
```

