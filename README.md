## bmsjs

![](https://travis-ci.org/bokuweb/bmsjs.svg?branch=master)

*** work in progress ***

browser bms player project.

### Dependencies

* cocos2d-JS Full v3.6.1
* CoffeeScript v1.9.2
* Gulp v3.8.11
* bower v1.3.12

### Installation

1. Install cocos2d-JS   
download here cocos2d-JS v3.6.1, and execute ```setup.py```.   
http://www.cocos2d-x.org/download

2. Create cocos2d-JS project

  ```
  cocos new bmsjs -l js -d .
  ```   
3. Clone this repository and overwrite to bmsjs(cocos2d-JS project) directory

4. Install packages

  ```
  npm i
  bower i
  ```

5. Build app
  build *.coffee to main.js
  ```
  gulp build 
  ```

6. Run on browser
  ```
  cocos run -p web
  ```
   
### Run test

#### Run test on PhantomJS

  ```
  gulp test
  ```
  
#### Run test on your browser

  ```
  gulp build
  ```
  
  Access ```test/runner.html```.
  

### Online demo

http://bokuweb.github.io/bmsjs

### License

<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br /><a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)</a>
