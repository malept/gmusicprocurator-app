const child_process = require('child_process');

const package = require('./package.json');
const gitRevisionTimestamp = child_process.spawnSync('git', ['show', '--format="format:%at"', '-q']).stdout

function debianIcons() {
  let icons = {}
  for (size of [48, 64, 128, 256]) {
    icons[`${size}x${size}`] = `src/icon-${size}.png`
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
      // 'rpm',
      // 'flatpak',
      // 'zip'
    ]
  },
  electronPackagerConfig: {
    'build-version': `${package.version}.${gitRevisionTimestamp}`
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