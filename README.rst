==========================
GMusicProcurator (the App)
==========================

.. image:: https://travis-ci.org/malept/gmusicprocurator-app.svg?branch=master
    :target: https://travis-ci.org/malept/gmusicprocurator-app

Embeds the web frontend of a running GMusicProcurator_ web application inside
of an Electron_ shell.

.. _GMusicProcurator: https://gmusicprocurator.readthedocs.org/
.. _Electron: http://electron.atom.io/

Building
--------

1. Install librsvg (specifically on Debian/Ubuntu, ``librsvg2-bin``).
2. Install ``icnsutils`` (specifically, the package that installs ``png2icns``
   - on macOS, it's named ``libicns`` in Homebrew).
3. To build for Windows, install ``icoutils`` (which generates the icon for the
   Windows binary).
4. To build for Windows on a non-Windows build machine, install ``wine``, to
   properly modify the Windows binaries.
5. Install `GNU Make`_ if it's not already on your system.
6. Clone this Git repository.
7. Run ``npm install``. (Yarn does not work on Linux/Windows because of problems
   with optional, OS-specific dependencies.)
8. Build the app for your OS via ``make``. You could try to build for the
   non-host OSes, but it's not recommended.

Running
-------

1. `Install and run GMusicProcurator`_ (with web UI frontend) on the target OS.
2. Run the app in your target OS.

.. _Install and run GMusicProcurator:
    https://gmusicprocurator.readthedocs.org/en/latest/install.html
.. _GNU Make: https://www.gnu.org/software/make/
