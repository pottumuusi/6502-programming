Following a tutorial which can be found from:
        http://anton.maurovic.com/posts/nintendo-nes-gamedev-part-1-setting-up/

At the moment Makefile acts as a frontend to different scripts.

For setting up, building and deploying a NES program:
    make all

If 'make all' executes targets in wrong order the following could be tried:
    make setup && make build && make deploy

Make targets can also be ran individually.

Example development workflow:
1. change program
2. 'make build'
3. 'make deploy'
