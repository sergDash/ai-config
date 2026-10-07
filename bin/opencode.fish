#!/usr/bin/fish

if test (count $argv) -lt 1
    echo "Usage: $argv[0] VERSION"
    exit 1
end

set VER $argv[1]

function fail
    echo "Ошибка: команда завершилась с кодом $status" >&2
    exit 1
end

cd ~/src/opencode/; or fail

git fetch origin; or fail
git fetch --tags; or fail
git switch -f dev; or fail
git reset --hard origin/dev; or fail

git switch --detach v$VER; or fail
bun install; or fail

git apply ~/bin/opencode-1.patch; or fail
git apply ~/bin/opencode-2.patch; or fail
git apply ~/bin/opencode-3.patch; or fail

# Если не указать версию, будет 0.0.0--дата
OPENCODE_VERSION=$VER ./packages/opencode/script/build.ts --single; or fail
cp ./packages/opencode/dist/opencode-linux-x64/bin/opencode ~/bin/opencode-$VER; or fail
cd ~/bin/; or fail
ln -sf opencode-$VER opencode; or fail


# Как создавать патч
# git commit -m "fix"
# git format-patch -1 HEAD
# cp 0001-fix.patch ~/bin/opencode-0001.patch
