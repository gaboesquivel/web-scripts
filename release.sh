# this message is logged by semantic-release when one of the commits found by web-scripts should trigger a release
expected_release_message="The release type for the commit is"

echo "spotify/web-scripts: Running semantic-release in --dry-run to see if we should trigger a lerna release."
yarn web-scripts release --dry-run | grep "${expected_release_message}"

if [ $? -eq 0 ]
then
  echo "spotify/web-scripts: A release will be triggered."
  echo "spotify/web-scripts: Configuring git for Github Actions Lerna publish..."
  git config --global user.email "no-reply@spotify.com"
  git config --global user.name "GitHub Action"
  git remote set-url origin "https://${GH_USERNAME}:${GH_TOKEN}@github.com/spotify/web-scripts.git"
  git checkout master
  echo "spotify/web-scripts: Configuring yarn for Github Actions Lerna publish..."
  yarn config set _authToken $NPM_TOKEN
  echo "spotify/web-scripts: Attempting publish..."
  yarn lerna publish --yes --conventional-commits --registry=https://registry.npmjs.com
  exit $?
else
  echo "spotify/web-scripts: No release will be triggered." >&2
  exit 0
fi
