  import { check } from "k6";
  import http from "k6/http";
  
  export default function() {
      let res = http.get("http://192.168.64.6:32008");
      check(res, {
          "is status 200": (r) => r.status === 200
      });
  };
  