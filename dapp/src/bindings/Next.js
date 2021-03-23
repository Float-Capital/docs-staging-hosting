// Generated by ReScript, PLEASE EDIT WITH CARE


var Req = {};

var Res = {};

var GetServerSideProps = {
  Req: Req,
  Res: Res
};

var GetStaticProps = {};

var GetStaticPaths = {};

var Link = {};

var Events = {};

function pushShallow(routerObj, queryString) {
  routerObj.push(queryString, undefined, {
        shallow: true
      });
  
}

function pushObjShallow(routerObj, pathObj) {
  routerObj.push(pathObj, undefined, {
        shallow: true
      });
  
}

var Router = {
  Events: Events,
  pushShallow: pushShallow,
  pushObjShallow: pushObjShallow
};

var Head = {};

var $$Error = {};

var Dynamic = {};

export {
  GetServerSideProps ,
  GetStaticProps ,
  GetStaticPaths ,
  Link ,
  Router ,
  Head ,
  $$Error ,
  Dynamic ,
  
}
/* No side effect */
