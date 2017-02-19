const child_process = require('child_process');
const path = require('path');

const package = require('./package.json');
const gitRevisionTimestamp = child_process.spawnSync('git', ['show', '--format=%at', '-q'], {encoding: 'utf8'}).stdout.trim();

let icons = {};
for (size of [48, 128, 256]) {
  icons[`${size}x${size}`] = `src/icon-${size}.png`;
}

const categories = ['Audio', 'Player'];

const linuxConfig = {
  categories: categories,
  icon: icons
};

let packagerConfig = {
  'build-version': `${package.version}.${gitRevisionTimestamp}`,
  icon: 'src/icon'
};

if (process.env.CI && process.env.TRAVIS_OS_NAME != 'osx') {
  packagerConfig.download = {
    cache: path.resolve(__dirname, '.electron')
  }
  packagerConfig.ignore = ['\.electron']
}

module.exports = {
  make_targets: {
    win32: [
      'squirrel',
      'zip'
    ],
    darwin: [
      'dmg',
      'zip'
    ],
    linux: [
      'deb',
      'rpm',
      'flatpak',
      'zip'
    ]
  },
  electronPackagerConfig: packagerConfig,
  electronWinstallerConfig: {
    name: package.productName
  },
  electronInstallerDebian: Object.assign({
    arch: 'any',
    bin: package.productName,
    section: 'sound'
  }, linuxConfig),
  electronInstallerFlatpak: Object.assign({
    genericName: 'Music Player',
    id: 'com.malept.gmusicprocurator'
  }, linuxConfig),
  electronInstallerRedhat: linuxConfig
}
