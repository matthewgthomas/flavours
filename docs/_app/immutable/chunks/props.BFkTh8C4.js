import{S as O,J as k,K as ee,L as g,M as re,N as w,O as S,U as v,l as p,F as q,P as ne,Q as se,w as ie,h as F,I as te,b as ae,E as fe,R as ue,V as le,H as ce,W as B,X as M,a as U,Y as H,c as de,Z as oe,_ as _e,j as C,$ as ve,a0 as be,a1 as Q,n as K,a2 as he,a3 as pe,a4 as W,a5 as we,a6 as Pe,a7 as ge,a8 as Z,a9 as ye,v as Re,aa as Ee,ab as Ie,ac as X,o as $,ad as Oe,ae as G,af as N,ag as Se}from"./runtime.CflPdt18.js";import{s as xe}from"./index-client.BiXb4ksz.js";function I(e,r=null,t){if(typeof e!="object"||e===null||O in e)return e;const n=se(e);if(n!==k&&n!==ee)return e;var i=new Map,l=ie(e),b=g(0);l&&i.set("length",g(e.length));var P;return new Proxy(e,{defineProperty(c,s,a){(!("value"in a)||a.configurable===!1||a.enumerable===!1||a.writable===!1)&&re();var u=i.get(s);return u===void 0?(u=g(a.value),i.set(s,u)):w(u,I(a.value,P)),!0},deleteProperty(c,s){var a=i.get(s);if(a===void 0)s in c&&i.set(s,g(v));else{if(l&&typeof s=="string"){var u=i.get("length"),f=Number(s);Number.isInteger(f)&&f<u.v&&w(u,f)}w(a,v),V(b)}return!0},get(c,s,a){var _;if(s===O)return e;var u=i.get(s),f=s in c;if(u===void 0&&(!f||(_=S(c,s))!=null&&_.writable)&&(u=g(I(f?c[s]:v,P)),i.set(s,u)),u!==void 0){var d=p(u);return d===v?void 0:d}return Reflect.get(c,s,a)},getOwnPropertyDescriptor(c,s){var a=Reflect.getOwnPropertyDescriptor(c,s);if(a&&"value"in a){var u=i.get(s);u&&(a.value=p(u))}else if(a===void 0){var f=i.get(s),d=f==null?void 0:f.v;if(f!==void 0&&d!==v)return{enumerable:!0,configurable:!0,value:d,writable:!0}}return a},has(c,s){var d;if(s===O)return!0;var a=i.get(s),u=a!==void 0&&a.v!==v||Reflect.has(c,s);if(a!==void 0||q!==null&&(!u||(d=S(c,s))!=null&&d.writable)){a===void 0&&(a=g(u?I(c[s],P):v),i.set(s,a));var f=p(a);if(f===v)return!1}return u},set(c,s,a,u){var R;var f=i.get(s),d=s in c;if(l&&s==="length")for(var _=a;_<f.v;_+=1){var y=i.get(_+"");y!==void 0?w(y,v):_ in c&&(y=g(v),i.set(_+"",y))}f===void 0?(!d||(R=S(c,s))!=null&&R.writable)&&(f=g(void 0),w(f,I(a,P)),i.set(s,f)):(d=f.v!==v,w(f,I(a,P)));var h=Reflect.getOwnPropertyDescriptor(c,s);if(h!=null&&h.set&&h.set.call(u,a),!d){if(l&&typeof s=="string"){var x=i.get("length"),T=Number(s);Number.isInteger(T)&&T>=x.v&&w(x,T+1)}V(b)}return!0},ownKeys(c){p(b);var s=Reflect.ownKeys(c).filter(f=>{var d=i.get(f);return d===void 0||d.v!==v});for(var[a,u]of i)u.v!==v&&!(a in c)&&s.push(a);return s},setPrototypeOf(){ne()}})}function V(e,r=1){w(e,e.v+r)}function Fe(e,r,t=!1){F&&te();var n=e,i=null,l=null,b=v,P=t?fe:0,c=!1;const s=(u,f=!0)=>{c=!0,a(f,u)},a=(u,f)=>{if(b===(b=u))return;let d=!1;if(F){const _=n.data===ue;!!b===_&&(n=le(),ce(n),B(!1),d=!0)}b?(i?M(i):f&&(i=U(()=>f(n))),l&&H(l,()=>{l=null})):(l?M(l):f&&(l=U(()=>f(n))),i&&H(i,()=>{i=null})),d&&B(!0)};ae(()=>{c=!1,r(s),c||a(null,null)},P),F&&(n=de)}function z(e,r){return e===r||(e==null?void 0:e[O])===r}function qe(e={},r,t,n){return oe(()=>{var i,l;return _e(()=>{i=l,l=[],C(()=>{e!==t(...l)&&(r(e,...l),i&&z(t(...i),e)&&r(null,...i))})}),()=>{ve(()=>{l&&z(t(...l),e)&&r(null,...l)})}}),e}let D=!1;function Ce(e,r,t){const n=t[r]??(t[r]={store:null,source:Q(void 0),unsubscribe:K});if(n.store!==e)if(n.unsubscribe(),n.store=e??null,e==null)n.source.v=void 0,n.unsubscribe=K;else{var i=!0;n.unsubscribe=xe(e,l=>{i?n.source.v=l:w(n.source,l)}),i=!1}return p(n.source)}function Ke(e,r,t){let n=t[r];return n&&n.store!==e&&(n.unsubscribe(),n.unsubscribe=K),e}function Ye(e,r){return e.set(r),r}function je(){const e={};return be(()=>{for(var r in e)e[r].unsubscribe()}),e}function Be(e,r,t){return e.set(t),r}function Te(e){var r=D;try{return D=!1,[e(),D]}finally{D=r}}const Ae={get(e,r){if(!e.exclude.includes(r))return p(e.version),r in e.special?e.special[r]():e.props[r]},set(e,r,t){return r in e.special||(e.special[r]=De({get[r](){return e.props[r]}},r,W)),e.special[r](t),G(e.version),!0},getOwnPropertyDescriptor(e,r){if(!e.exclude.includes(r)&&r in e.props)return{enumerable:!0,configurable:!0,value:e.props[r]}},deleteProperty(e,r){return e.exclude.includes(r)||(e.exclude.push(r),G(e.version)),!0},has(e,r){return e.exclude.includes(r)?!1:r in e.props},ownKeys(e){return Reflect.ownKeys(e.props).filter(r=>!e.exclude.includes(r))}};function Me(e,r){return new Proxy({props:e,exclude:r,special:{},version:g(0)},Ae)}const Ne={get(e,r){let t=e.props.length;for(;t--;){let n=e.props[t];if(N(n)&&(n=n()),typeof n=="object"&&n!==null&&r in n)return n[r]}},set(e,r,t){let n=e.props.length;for(;n--;){let i=e.props[n];N(i)&&(i=i());const l=S(i,r);if(l&&l.set)return l.set(t),!0}return!1},getOwnPropertyDescriptor(e,r){let t=e.props.length;for(;t--;){let n=e.props[t];if(N(n)&&(n=n()),typeof n=="object"&&n!==null&&r in n){const i=S(n,r);return i&&!i.configurable&&(i.configurable=!0),i}}},has(e,r){if(r===O||r===X)return!1;for(let t of e.props)if(N(t)&&(t=t()),t!=null&&r in t)return!0;return!1},ownKeys(e){const r=[];for(let t of e.props){N(t)&&(t=t());for(const n in t)r.includes(n)||r.push(n)}return r}};function Ue(...e){return new Proxy({props:e},Ne)}function J(e){for(var r=q,t=q;r!==null&&!(r.f&(Pe|ge));)r=r.parent;try{return Z(r),e()}finally{Z(t)}}function De(e,r,t,n){var j;var i=(t&ye)!==0,l=!Re||(t&Ee)!==0,b=(t&Ie)!==0,P=(t&Se)!==0,c=!1,s;b?[s,c]=Te(()=>e[r]):s=e[r];var a=O in e||X in e,u=((j=S(e,r))==null?void 0:j.set)??(a&&b&&r in e?o=>e[r]=o:void 0),f=n,d=!0,_=!1,y=()=>(_=!0,d&&(d=!1,P?f=C(n):f=n),f);s===void 0&&n!==void 0&&(u&&l&&he(),s=y(),u&&u(s));var h;if(l)h=()=>{var o=e[r];return o===void 0?y():(d=!0,_=!1,o)};else{var x=J(()=>(i?$:Oe)(()=>e[r]));x.f|=pe,h=()=>{var o=p(x);return o!==void 0&&(f=void 0),o===void 0?f:o}}if(!(t&W))return h;if(u){var T=e.$$legacy;return function(o,E){return arguments.length>0?((!l||!E||T||c)&&u(E?h():o),o):h()}}var R=!1,Y=!1,m=Q(s),A=J(()=>$(()=>{var o=h(),E=p(m);return R?(R=!1,Y=!0,E):(Y=!1,m.v=o)}));return i||(A.equals=we),function(o,E){if(arguments.length>0){const L=E?p(A):l&&b?I(o):o;return A.equals(L)||(R=!0,w(m,L),_&&f!==void 0&&(f=L),C(()=>p(A))),o}return p(A)}}export{I as a,qe as b,Ye as c,Ce as d,Ue as e,Ke as f,Be as g,Fe as i,Me as l,De as p,je as s};
