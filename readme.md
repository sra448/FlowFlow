# FlowFlow

https://flowflow.ch/

## The plan

- [ ] make a nice webapp
- [ ] make it a progressive webapp
- [ ] maybe conquer the world

## Install and run locally

### Installation

```
git clone git@github.com:sra448/FlowFlow.git ./FlowFlow
cd ./FlowFlow/
npm install -g webpack
npm install -g http-serve
npm install
```

### Start webpack 

```
cd ./FlowFlow/
webpack -w
```

### Start server

(On a second command line)


```
cd ./FlowFlow/app/
http-serve
```

FlowFlow should now be available at `http://localhost:8080` (or whatever port `http-serve` tells you).

