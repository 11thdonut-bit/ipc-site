# Deploying inpl.space

Repo: https://github.com/11thdonut-bit/ipc-site  (default branch `main`)

The site is one self-contained file. No build step, no dependencies.

## Read this first

Your repo is already live and already has files in it:

    CNAME                 <- the custom domain. DO NOT DELETE OR OVERWRITE.
    favicon.ico           <- keep. index.html now links to it.
    earth-moon-orbit.jpg  <- the old site's image. Nothing uses it now,
                             but deleting it is your call, not the deploy's.
    README.md             <- keep
    index.html            <- this is what gets replaced
    sitemap.xml           <- gets replaced

So this is **not** a fresh push. Do not run `git init` in this folder and
force-push it over the repo: that deletes CNAME and takes the domain down.
Clone the repo and copy the new files in instead.

(There is a `_to_delete/` folder here holding a spare CNAME I generated before
I could see your repo. It is identical to yours and is not needed. Drag it to
the trash whenever.)

## The one-step way

Open Terminal and run:

    bash ~/Desktop/"IPC Design"/site/push.sh

It clones (or refreshes) the repo, copies the new build in, checks that
nothing is being deleted and that CNAME still says inpl.space, shows you
exactly what will be published, and asks before pushing. Answer anything
other than `y` and it stops without touching the repo.

The only thing it cannot do for you is sign in. When git asks for a
username and password, the password is a personal access token, not your
GitHub password:
github.com > Settings > Developer settings > Personal access tokens >
Tokens (classic) > Generate new token, tick `repo`.

To have the Mac remember it so you are only asked once:

    git config --global credential.helper osxkeychain

If git asks who you are:

    git config --global user.name "Neven Husson"
    git config --global user.email "neven@inpl.space"

## The same thing by hand


    cd ~/Desktop
    git clone https://github.com/11thdonut-bit/ipc-site.git
    cd ipc-site

    cp ~/Desktop/"IPC Design"/site/index.html   .
    cp ~/Desktop/"IPC Design"/site/sitemap.xml  .
    cp ~/Desktop/"IPC Design"/site/robots.txt   .
    cp ~/Desktop/"IPC Design"/site/.nojekyll    .

    git status          # should show index.html + sitemap.xml modified,
                        # robots.txt + .nojekyll added, CNAME untouched
    git add -A
    git commit -m "New site"
    git push

If `git status` shows `CNAME` as deleted, stop and run `git checkout CNAME`
before committing.

If git asks who you are, set it once:

    git config --global user.name "Neven Husson"
    git config --global user.email "neven@inpl.space"

GitHub does not accept passwords over https. When it asks for one, paste a
personal access token: github.com > Settings > Developer settings >
Personal access tokens > Tokens (classic) > Generate new token, `repo` scope.

## Updating later

The clone stays on your Desktop. Each time there is a new build:

    cp ~/Desktop/"IPC Design"/site/index.html ~/Desktop/ipc-site/
    cd ~/Desktop/ipc-site
    git add -A && git commit -m "Update" && git push

Pages redeploys in under a minute. Hard-refresh (Cmd-Shift-R) to see it.

## Nothing to do for DNS

The repo already has a CNAME and the site is already live on the domain, so
the DNS records already point at GitHub. Leave them alone.
