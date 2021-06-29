  import { check } from "k6";
  import http from "k6/http";
  
  export default function() {
      let res = http.get("http://daas.digidhamu.com/");
      check(res, {
          "is status 200": (r) => r.status === 200
      });
  };
  