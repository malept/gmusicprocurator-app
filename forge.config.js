const child_process = require('child_process');

const package = require('./package.json');
const gitRevisionTimestamp = child_process.spawnSync('git', ['show', '--format=%at', '-q'], {encoding: 'utf8'}).stdout.trim();

function debianIcons() {
  let icons = {};
  for (size of [48, 128, 256]) {
    icons[`${size}x${size}`] = `src/icon-${size}.png`;
  }

  return icons;
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
      // 'flatpak',
      'zip'
    ]
  },
  electronPackagerConfig: {
    'build-version': `${package.version}.${gitRevisionTimestamp}`,
    ignore: ['/electron-packager']
  },
  electronWinstallerConfig: {
    name: 'GMusicProcurator'
  },
  electronInstallerDebian: {
    arch: 'any',
    categories: ['Audio', 'Player'],
    icon: debianIcons(),
    section: 'sound'
  },
  electronInstallerFlatpak: {},
  electronInstallerRedhat: {}
}
