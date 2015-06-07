==========================
GMusicProcurator (the App)
==========================

Embeds the web frontend of a running GMusicProcurator_ web application inside
of an Electron_ shell.

.. _GMusicProcurator: https://gmusicprocurator.readthedocs.org/
.. _Electron: https://electron.github.io/

Building
--------

1. `Install and run GMusicProcurator`_ (with web UI frontend).
2. Install librsvg (specifically on Debian/Ubuntu, ``librsvg2-bin``).
3. On OSX, install ``makeicns`` (e.g, via Homebrew). On other OSes, install
   ``icnsutils`` (specifically, the package that installs ``png2icns``).
4. Install ``icoutils`` (generates the icon for the Windows binary).
5. Install ``wine`` if you're not on Windows, to properly modify the
   Windows binaries.
6. Install `GNU Make`_ if it's not already on your system.
7. Clone this Git repository.
8. Run ``npm install``.
9. Build the app for your OS and architecture, see the ``Makefile`` for the
   specific target. For example, for Linux on a 64 bit architecture, run
   ``make dist-linux-x64``. If you run ``make`` without a target, distributions
   for all supported OSes will be built.

.. _Install and run GMusicProcurator:
    https://gmusicprocurator.readthedocs.org/en/latest/install.html
.. _GNU Make: https://www.gnu.org/software/make/
