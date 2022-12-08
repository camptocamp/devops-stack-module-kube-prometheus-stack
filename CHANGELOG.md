# Changelog

## [2.0.0-alpha.1](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v1.0.0-alpha.1...v2.0.0-alpha.1) (2022-12-08)


### ⚠ BREAKING CHANGES

* **azure:** delete useless resource group variable and clean up

### Bug Fixes

* **aks:** add azure main ([bb3ff9d](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/bb3ff9dd0738f061b1e3e019ea88209b04814741))
* **aks:** eof ([646274f](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/646274f12e9b5838f0c32083def377dc6a3fcda0))
* do not expose values as secret ([f78b559](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/f78b559a1a5a211df81a9bebf5740a563b518edd))
* wait for app, else provider says app is not existent on destroy ([29e6187](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/29e6187a53722e2834a9a13f3b37bc1d16cbd720))


### Miscellaneous Chores

* **azure:** delete useless resource group variable and clean up ([7b34f0e](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/7b34f0ef054205dba1ff4d01cfcf116426c3f56e))

## 1.0.0-alpha.1 (2022-11-18)


### ⚠ BREAKING CHANGES

* move Terraform module at repository root
* use var.cluster_info

### Features

* add aks profile ([58ea344](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/58ea344cd52ed80d804f91e5a62846f5eb6d5186))
* add namespace var ([8b86be0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/8b86be08a6ec00cd537e861ae7907400b1be271f))
* allow multiple profiles ([bc632aa](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/bc632aa489e55dc586bc944c9fc4b64353d5f853))
* **azure:** add module ([541d2c7](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/541d2c748e2fe8337655bae0cb8afce5cecd3cd8))
* change the way the datasource is selected ([#12](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/12)) ([f7e9391](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/f7e9391629211aa962de1f74524b84cad7176422))
* initial implementation ([3eeae08](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/3eeae082ffd459bdf0ff0733cd74eab97f74a0b5))
* make variables optional ([a97ab6f](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/a97ab6f85f7e056fcb4eef5879e81865ec397654))
* **output:** add grafana_admin_password ([c56d133](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/c56d1336b40820dade4e7119c9c83127fa2a99fa))
* simplify application ([779d833](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/779d833bf24418ce72ca75abaa450f2e3796befc))
* support profiles ([67e6c80](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/67e6c8025fc8ba3c3dbbb95cec1dfe00809a41c9))
* Take argocd namespace as variable ([75cdad1](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/75cdad1738c591012ba1e0a850b044e58b5487bb))
* **thanos:** add needed configuration and resources to deploy Thanos ([#8](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/8)) ([a2d5b3c](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/a2d5b3c0110be0f01fa9e995f1a427b6837dbbc3))
* upgrade chart to v40 ([#13](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/13)) ([6401ae7](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/6401ae7ddf8986f847b966e1b56d6c2898794c1e))
* upgrade kube-prometheus-chart to v36 ([#11](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/11)) ([156aa28](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/156aa28176865fae8d47a6285b743ad7ee738d37))
* use argocd_namespace variable like other modules ([55a21ac](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/55a21acb06968e620cc5ce1758c30038ffb372d1))
* use argocd.namespace as annotation (force dep) ([33c80c3](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/33c80c3070f77aea1f2ae010326339a8f90d3cb7))
* wait for app ([9307551](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/930755104ea0745662c1094c57796a8dd0ec920d))


### Bug Fixes

* :bug: readd kube-system as valid destination ([#9](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/9)) ([74faa5f](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/74faa5fae01c0b18ca2bc376cf70c139d5d1a1a5))
* add argocd project and point to main ([56765c1](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/56765c158f1e818e5f9a97e0106aebf5efb152fb))
* add cookie_secret ([15f86db](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/15f86db756ebd7e77cf3caa6a3367b9965558740))
* add missing Alertmanager ingress TLS config ([1e2ac96](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/1e2ac9653bcc545569b5b82ca23ae49f5cf494e4))
* allow kube-system namespace ([6881167](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/688116750ccf05d6928bd41892fe07dad47a4b7d))
* annotation prefix ([f665a16](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/f665a166bf273d3f88b955035c02740fa3b2f823))
* application requires project ([ce144e7](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/ce144e73f7ed7d9b481c1c29c17f2773077fbb5f))
* application sync policy ([c1bc4c2](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/c1bc4c2e0c9fb2694e3272d0381344ef9cac4aff))
* change target_revision back to main ([#14](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/14)) ([37ed82d](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/37ed82dc7efc88721a72d63f0a192a78a3804096))
* correct the namespace with " ([#10](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/10)) ([eee6b22](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/eee6b22897aac36beb5b16d93158c4e61d6b43f4))
* create namespace ([f4f2aea](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/f4f2aeac226a12a2008aa169e1a75a40d4d13753))
* deploy project and app to argocd namespace ([ec9f342](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/ec9f342db194db28eefc81c4ebffb8159035f142))
* do not delay Helm values evaluation ([20c1296](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/20c12966cdb82938d21214b80ca68f5e3f94384c))
* **grafana:** correct URL for the datasource ([d80a3ff](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/d80a3ff0f9c3337a1106fb2ca1571ae6bb37fff4))
* **grafana:** generate grafana admin password ([8136be0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/8136be07245fbef30a953e0930880220a8f89778))
* merge conflicts ([1e1e005](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/1e1e00560a6c7040ab6f4a23ddb79e0ce9a3f715))
* pass kubernetes block param by param ([839aeac](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/839aeac6c4c7a3d5afaa50ce6ce2583c834e24dc))
* README ([50f3584](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/50f35848f8423bef68750daa170e6d11d8feed30))
* rename var resource group name and document its purpose ([e007997](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/e007997cc01fffa8d68554088547c60e9e9b6db8))
* **template:** pass down metrics_archives ([4ecbbe3](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/4ecbbe3e22a57c1b6b998abce98c79426a7a9df3))
* test argocd provider with portforward ([86943f6](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/86943f64247944dd8943ac9ccf6b04f8612f03a9))
* test with port_forward_with_namespace ([fa6567e](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/fa6567e83111e7da529a387d2caf6bb85814c322))
* test with var.kubernetes ([2b95682](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/2b956829cabef1e665fa05b8a4453b3b8261d412))
* **thanos:** add can to avoid error when thanos is not deployed ([5b2c7ad](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/5b2c7ad349c012169603e57b0f7bcd224ecb6c91))
* use .git in source_repos ([4bb58c6](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/4bb58c6ca72e355fd4264bb7c3a64f0e534d26fc))
* use different OIDC configuration per component ([18fd0b3](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/18fd0b3c92150bb6ca893ece60c8375ad8c97b68))
* **variables:** add metrics_archives ([8e55b3e](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/8e55b3e66f2d1185ecca79feb911d0a64884418f))
* wrong URL for application ([179b13f](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/179b13ff7b1a4a2ae00979a572e0f5c309c9906a))


### Code Refactoring

* move Terraform module at repository root ([fdff488](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/fdff48843d96ae33915683cd82f825c3df89f2a1))
* use var.cluster_info ([54eb270](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/54eb270ad661c8cf826bef6c25910698d0a764f5))


### Continuous Integration

* add central workflows including release-please ([#17](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/17)) ([1a965c5](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/1a965c5ebc3173fd6d210b4a37c689f55954f0c8))
