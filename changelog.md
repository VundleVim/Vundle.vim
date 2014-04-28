Change Log
==========
F = Feature, B = Bug Fix, D = Doc Change

### Version 0.10.2

- B: #430 Put user script directories before system directories in rtp
- B: #455 Rename functions that start with `g:` + lowercase letter (Vim patch 7.4.264)

### Version 0.10.1
- B: #451 Escape spaces when handling rtp directories

### Version 0.10
- F: #415 Support plugin pinning (for non-git repos & preventing updates)
- F: #440 Detect plugin name collisions
- F: #418 Deferred rtp manipulation (speeds up start)
- B: #418 Leave default rtp directories (i.e. ~/.vim) where they should be
- B: #429 Fix newline character in log
- B: #440 Detect changed remotes & update repos
- D: #435 Image update in README.md
- D: #419 Add function documentation
- D: #436 Rename vundle to Vundle.vim, add modelines, quickstart update
