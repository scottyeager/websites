# tools to run ThreeFold web env

starting point to run all websites on your local machine

- blog
- wiki's
- websites

## get started
 - install tfweb
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/threefoldfoundation/websites/master/tools/install.sh)"
```
 - start tfweb 
 ```
cd ~/code/github/crystaluniverse/publishingtools;tfweb -c ~/code/github/threefoldfoundation/websites/config.toml

```
important to start in publishingtools dir otherwise it will not start the blog

## developers

### to build

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/threefoldfoundation/websites/master/tools/build.sh)"
```

## information about tools inside

- https://github.com/crystaluniverse/publishingtools (is the tfweb, our webserver which can host wiki's, websites, blogs, ...)
   - unfortunately no manual, needs to be created
- https://github.com/crystaluniverse/crystaltools
   - there is a manual inside
   
when starting tfweb, it will also start the manuals for publishingtools & crystaltools

## troubeshooting

### OSX

- once brew installed do

```
brew update
brew upgrade
```

and try again, see if brew worked well



