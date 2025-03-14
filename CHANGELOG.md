# Changelog

## [14.2.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v14.1.0...v14.2.0) (2025-03-13)


### Features

* add pvc for alertmanager data ([#146](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/146)) ([705411f](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/705411f20cada5092cf4070b0e510c8066cb94cc))

## [14.1.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v14.0.0...v14.1.0) (2025-02-19)


### Features

* add distinct to avoid duplicates in ingreses hosts lists ([19a88cd](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/19a88cdecbe01b10ac4899431b63b443dd7cc71e))

## [14.0.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v13.0.1...v14.0.0) (2025-02-19)


### ⚠ BREAKING CHANGES

* **chart:** major update of dependencies on kube-prometheus-stack chart

### Features

* **chart:** major update of dependencies on kube-prometheus-stack chart ([edaf38e](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/edaf38e2001101ac0360776c2bd0e5a968915b29))

## [13.0.1](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v13.0.0...v13.0.1) (2024-10-31)


### Bug Fixes

* **aks:** add merge() to avoid null value that breaks values generation ([2aaf510](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/2aaf5108456e9540aac99b6fc70a398136c14818))
* change registry of cURL image to avoid rate limits and update it ([6c7e60b](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/6c7e60b45a23eba370a33796421618c0143d5835))

## [13.0.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v12.0.0...v13.0.0) (2024-10-09)


### ⚠ BREAKING CHANGES

* point the Argo CD provider to the new repository ([#133](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/133))

### Features

* point the Argo CD provider to the new repository ([#133](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/133)) ([f69deb2](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/f69deb2a68ff31972ce186970f28971e1d403179))

### Migrate provider source `oboukili` -> `argoproj-labs`

We've tested the procedure found [here](https://github.com/argoproj-labs/terraform-provider-argocd?tab=readme-ov-file#migrate-provider-source-oboukili---argoproj-labs) and we think the order of the steps is not exactly right. This is the procedure we recommend (**note that this should be run manually on your machine and not on a CI/CD workflow**):

1. First, make sure you are already using version 6.2.0 of the `oboukili/argocd` provider.

1. Then, check which modules you have that are using the `oboukili/argocd` provider.

```shell
$ terraform providers

Providers required by configuration:
.
├── provider[registry.terraform.io/hashicorp/helm] 2.15.0
├── (...)
└── provider[registry.terraform.io/oboukili/argocd] 6.2.0

Providers required by state:

    (...)

    provider[registry.terraform.io/oboukili/argocd]

    provider[registry.terraform.io/hashicorp/helm]
```

3. Afterwards, proceed to point **ALL*  the DevOps Stack modules to the versions that have changed the source on their respective requirements. In case you have other personal modules that also declare `oboukili/argocd` as a requirement, you will also need to update them.

4. Also update the required providers on your root module. If you've followed our examples, you should find that configuration on the `terraform.tf` file in the root folder.

5. Execute the migration  via `terraform state replace-provider`:

```bash
$ terraform state replace-provider registry.terraform.io/oboukili/argocd registry.terraform.io/argoproj-labs/argocd
Terraform will perform the following actions:

  ~ Updating provider:
    - registry.terraform.io/oboukili/argocd
    + registry.terraform.io/argoproj-labs/argocd

Changing 13 resources:

  module.argocd_bootstrap.argocd_project.devops_stack_applications
  module.secrets.module.secrets.argocd_application.this
  module.metrics-server.argocd_application.this
  module.efs.argocd_application.this
  module.loki-stack.module.loki-stack.argocd_application.this
  module.thanos.module.thanos.argocd_application.this
  module.cert-manager.module.cert-manager.argocd_application.this
  module.kube-prometheus-stack.module.kube-prometheus-stack.argocd_application.this
  module.argocd.argocd_application.this
  module.traefik.module.traefik.module.traefik.argocd_application.this
  module.ebs.argocd_application.this
  module.helloworld_apps.argocd_application.this
  module.helloworld_apps.argocd_project.this

Do you want to make these changes?
Only 'yes' will be accepted to continue.

Enter a value: yes

Successfully replaced provider for 13 resources.
```

6. Perform a `terraform init -upgrade` to upgrade your local `.terraform` folder.

7. Run a `terraform plan` or `terraform apply` and you should see that everything is OK and that no changes are necessary. 

## [12.0.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v11.1.1...v12.0.0) (2024-08-22)


### ⚠ BREAKING CHANGES

* **chart:** major update of dependencies on kube-prometheus-stack chart ([#126](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/126))

### Features

* **chart:** major update of dependencies on kube-prometheus-stack chart ([#126](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/126)) ([17f42a7](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/17f42a7b6dd7876eef4b7ef424ce212bb3572816))

## [11.1.1](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v11.1.0...v11.1.1) (2024-06-07)


### Bug Fixes

* **eks:** use name_prefix instead of name when creating a IAM policy ([#127](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/127)) ([5fc9c24](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/5fc9c24f93bc54b1bee41f4d57b19e0af9efba43))

## [11.1.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v11.0.0...v11.1.0) (2024-05-16)


### Features

* add Runbook URL on alertmanager template ([#124](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/124)) ([dbd2f36](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/dbd2f3628a978ba6b7b841f45fc3adb8c6f05a7d))

## [11.0.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v10.1.1...v11.0.0) (2024-04-23)


### ⚠ BREAKING CHANGES

* **eks:** add option to create IAM role for the metrics storage
  * This is a breaking change because the attributes of the `metrics_storage` variable has changed. Please check the README.adoc to see the differences.

### Features

* **eks:** add option to create IAM role for the metrics storage ([f678c15](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/f678c158662d98649694793e286c5059538f9f6e))

## [10.1.1](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v10.1.0...v10.1.1) (2024-04-17)


### Bug Fixes

* **aks:** update module to support workload identities ([3da046f](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/3da046f7222647cc84a0151b424e37fa50ae9f60))

## [10.1.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v10.0.0...v10.1.0) (2024-04-17)


### Features

* add variable to set resources with default values ([682aa85](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/682aa85f84c532920479319cd14d7930b3dbd7c4))
* upgrade images of OAuth Proxy and curl ([63d0fd4](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/63d0fd43ee05f1626b30de1c8c5b8187fd697d99))

## [10.0.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v9.2.1...v10.0.0) (2024-04-12)


### ⚠ BREAKING CHANGES

* **chart:** major update of dependencies on kube-prometheus-stack chart
  * an upgrade in-place should work;
  * most of the changes are image upgrades and the major versions are only bumped because some CRDs have changed;
  * Argo CD should take care of upgrading them for us, so we have no problems.

### Features

* **chart:** major update of dependencies on kube-prometheus-stack chart ([f4e52ec](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/f4e52ec098d23e523d9caa6c426272e3749c7f80))


### Bug Fixes

* disable leaked secrets assertion on grafana.ini ([8d2c1c2](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/8d2c1c2a56d0d94eff67474c0deded90669ca075))

## [9.2.1](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v9.2.0...v9.2.1) (2024-03-01)


### Bug Fixes

* remove legacy ingress annotations ([6ad2e83](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/6ad2e83d60fdb69b6acf732477a51da0007eb30e))

## [9.2.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v9.1.0...v9.2.0) (2024-02-23)


### Features

* add a subdomain variable ([6cd9bfe](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/6cd9bfec71fcffc07e2bcf65cf1cd078981f248e))


### Bug Fixes

* make subdomain variable non-nullable ([4af82f4](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/4af82f403c2e26e2b638ea87a2d70e89e5151613))
* remove annotation for the redirection middleware ([5f8d07f](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/5f8d07fc4ce5c9fa49598dfca78fb23e5079b812))

## [9.1.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v9.0.0...v9.1.0) (2024-02-09)


### Features

* enable the export of Thanos sidecar metrics ([#111](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/111)) ([b31dd5c](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/b31dd5caa1bee6d5069fb1a05391a6ae8a68b10b))

## [9.0.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v8.2.0...v9.0.0) (2024-01-19)


### ⚠ BREAKING CHANGES

* hardcode the release name to remove the destination cluster
* remove the ArgoCD namespace variable
* remove the namespace variable

### Bug Fixes

* add dependency on the namespace so it not created before Argo CD ([9e9648c](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/9e9648cdf58c16fd9e2209ea1b125efb81126534))
* disable SSL verification unless for prod issuer and change default issuer ([bd66f82](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/bd66f822198ba4273415427dcefbb61aafffd87f))
* hardcode the release name to remove the destination cluster ([a113f9c](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/a113f9c98bb6e37938d2ef13ce612e5bc6e46e53))
* remove the ArgoCD namespace variable ([d22e46b](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/d22e46b66c4f7d176b5168b23911c338b78aac98))
* remove the namespace variable ([0e7d1f7](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/0e7d1f711efbb8999e523b8b9845f1b880bd8f0a))

## [8.2.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v8.1.0...v8.2.0) (2023-12-18)


### Features

* **grafana:** create a variable to set a dataproxy time ([#105](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/105)) ([ee366c7](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/ee366c7faefe132563d5cc98c7274ec6bd14225d))

## [8.1.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v8.0.2...v8.1.0) (2023-12-15)


### Features

* **alertmanager:** continue matching ([#103](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/103)) ([5615736](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/561573696295de3f78eb7f398e968122e168f466))

## [8.0.2](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v8.0.1...v8.0.2) (2023-12-06)


### Bug Fixes

* **Grafana:** Thanos datasource url ([#99](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/99)) ([2a2c3af](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/2a2c3af4c196000c004366d7c9bbf04be75efcd1))

## [8.0.1](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v8.0.0...v8.0.1) (2023-12-06)


### Bug Fixes

* **Grafana:** increase timeout for long queries ([#100](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/100)) ([3cdd3a8](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/3cdd3a871c133149f4961a371c86913d9a4841b5))

## [8.0.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v7.1.0...v8.0.0) (2023-11-03)


### ⚠ BREAKING CHANGES

* remove the Helm diff ([#94](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/94))
* **chart:** major update of dependencies on kube-prometheus-stack chart ([#92](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/92)):

  - The v52.x of the chart changes multiple values on the Thanos settings of this chart. Note the following from their upgrade recommendations to see if you are affected:
    
    > This [upgrade] includes the ability to select between using existing secrets or create new secret objects for various thanos config. The defaults have not changed but if you were setting:
    >
    > `thanosRuler.thanosRulerSpec.alertmanagersConfig` or  
    > `thanosRuler.thanosRulerSpec.objectStorageConfig` or  
    > `thanosRuler.thanosRulerSpec.queryConfig` or  
    > `prometheus.prometheusSpec.thanos.objectStorageConfig`  
    > 
    > you will have to need to set existingSecret or secret based on your requirement
    >

### Features

* **chart:** major update of dependencies on kube-prometheus-stack chart ([#92](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/92)) ([79ad8de](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/79ad8de9df8e29868f71ebfc323eb2736d1c7992))


### Bug Fixes

* remove the Helm diff ([#94](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/94)) ([65fb62b](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/65fb62bd3e9ea63ed6ce37964135312d8e04e75c))

## [7.1.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v7.0.0...v7.1.0) (2023-10-19)


### Features

* add standard variables and variable to add labels to Argo CD app ([291051d](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/291051d0cde76d91ba6404541ded0cb4ca071100))
* add variables to set AppProject and destination cluster ([5a9370b](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/5a9370b1d98dfae521d1203577d140ebcd4fe0aa))
* update OAuth2-Proxy and curl images ([5a16bc5](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/5a16bc590b779f37ba2bfbff8d1b9a5be2f6e2e1))

## [7.0.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v6.3.0...v7.0.0) (2023-09-08)


### ⚠ BREAKING CHANGES

* **chart:** major update of dependencies on kube-prometheus-stack chart ([#89](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/89)) - an update in-place should work without any issues; this is a breaking change only because the underlying chart had a major bump because the minimum kubeVersion was bumped to ">=1.19.0-0".

### Features

* **chart:** major update of dependencies on kube-prometheus-stack chart ([#89](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/89)) ([4f6fbf4](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/4f6fbf4ee3e8bcdcf12a12074aad1d19d0480585))

## [6.3.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v6.2.0...v6.3.0) (2023-08-28)


### Features

* **chart:** minor update of dependencies on kube-prometheus-stack chart ([#87](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/87)) ([449f524](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/449f5243ac6a476af7f2c044e031b1a3c0d7ade1))

## [6.2.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v6.1.1...v6.2.0) (2023-08-24)


### 📝 NOTES

* This is a patch release that only changes a comment on a ServiceAccount. See [official release changelog](https://github.com/prometheus-community/helm-charts/releases/tag/kube-prometheus-stack-48.3.4).

### Features

* **chart:** patch update of dependencies on kube-prometheus-stack chart ([#85](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/85)) ([2b9cdab](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/2b9cdabc3715b36e4c0d580c4a77a5e92e408bf1))

## [6.1.1](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v6.1.0...v6.1.1) (2023-08-14)


### 📝 NOTES

* Due to the deactivation by default of the Helm templates on the Terraform plan, please note that the first time you apply this release, it will output a monstrous Terraform plan saying a resource will be deleted. **It is best that you apply this release with a `terraform apply -target` before making any other changes to your Terraform code.**

### Bug Fixes

* add variable to deactivate the output of Helm templates on plan ([#82](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/82)) ([a31abf3](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/a31abf3379c3cfad70b12dd7b39214e7b057b5a4))


## [6.1.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v6.0.1...v6.1.0) (2023-08-11)


### Features

* **chart:** minor update of dependencies on kube-prometheus-stack chart ([#80](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/80)) ([cf38521](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/cf38521ff047d01ed51291922712345056c4d2d7))

## [6.0.1](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v6.0.0...v6.0.1) (2023-08-09)


### Bug Fixes

* readd support to deactivate auto-sync which was broken by [#74](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/74) ([6fd4f48](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/6fd4f483e46f47ff39a24ea592bfc4c79bc36730))

## [6.0.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v5.0.0...v6.0.0) (2023-07-19)


### ⚠ BREAKING CHANGES

* upgrade kube-prometheus-chart to v48.1.1 - _as usual, the chart developers [recommend upgrading the CRDs manually](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack#from-47x-to-48x) although on our case Argo CD should take care of the task_.

### Features

* upgrade kube-prometheus-chart to v48.1.1 ([8495fc7](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/8495fc7a2751917330e5079d094d32a59d6d7aea))


### Bug Fixes

* add replace annotation to force the upgrade of all CRDs on sync ([fe0a6bc](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/fe0a6bc823d7e0c8a9a729a07e955e0635aa6fe0))

## [5.0.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v4.0.1...v5.0.0) (2023-07-11)


### ⚠ BREAKING CHANGES

* add support to oboukili/argocd v5 ([#74](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/74))

### Features

* add support to oboukili/argocd v5 ([#74](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/74)) ([1c0660f](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/1c0660f17b29f82158e077d1fe206278325cabde))

## [4.0.1](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v4.0.0...v4.0.1) (2023-07-04)


### Documentation

* add missing SKS symbolic link and sidebar link ([#72](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/72)) ([828d8cd](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/828d8cdc5c59d451f9a085ac24b9c614b6a5110d))

## [4.0.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v3.3.0...v4.0.0) (2023-07-03)


### ⚠ BREAKING CHANGES

* standardize and improve metrics variable

### Features

* add first version of the SKS variant ([f75f06c](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/f75f06c4bea25705956f444c7ea084809689341c))


### Bug Fixes

* standardize and improve metrics variable ([52392f6](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/52392f6c132ed2df3d6a941593170dd4d4b55f8d))

## [3.3.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v3.2.0...v3.3.0) (2023-06-30)


### Features

* add support for deadmanssnitch and slack notifications ([#69](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/69)) ([1ba82fb](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/1ba82fb10c7909ba85e0ba5e4568773e2d06cc00))

## [3.2.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v3.1.0...v3.2.0) (2023-06-15)


### Features

* diff k8s manifests ([#66](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/66)) ([96c7f50](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/96c7f50d097e970d1afc0d30ad730903251afbe4))

## [3.1.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v3.0.0...v3.1.0) (2023-06-05)


### Features

* upgrade OAuth2-Proxy images and add locals ([#64](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/64)) ([e1d60bd](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/e1d60bd040fb0aaa2817d6f64222f5a9e5c2ef0f))

## [3.0.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v2.3.0...v3.0.0) (2023-05-30)


### ⚠ BREAKING CHANGES

* remove unused outputs

### Bug Fixes

* remove unused outputs ([dd518ea](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/dd518eae2db5e6e90bbd496e021bbee3440efa83))

## [2.3.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v2.2.3...v2.3.0) (2023-05-15)


### Features

* **grafana:** re-enable Grafana by default ([#53](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/53)) ([cd1c324](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/cd1c324d6a181a864da95703e3707cc635a5942b))

## [2.2.3](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v2.2.2...v2.2.3) (2023-05-12)


### Bug Fixes

* improve services / monitoring customization ([#57](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/57)) ([6573168](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/65731685e33c3117c7db34b08c9d617fdb59a570))

## [2.2.2](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v2.2.1...v2.2.2) (2023-05-11)


### Bug Fixes

* **grafana:** ignore self-signed certificates for Grafana ([#52](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/52)) ([4dcaa8d](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/4dcaa8df344d8d53c8de065c846dd3f8d7d9b0d5))

## [2.2.1](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v2.2.0...v2.2.1) (2023-05-09)


### Bug Fixes

* **eks:** terraform error when var.metrics_storage is null ([#51](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/51)) ([a0ffd44](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/a0ffd44d8ae6a10e514f5e052fcf4cd3434e7dd7))

## [2.2.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v2.1.0...v2.2.0) (2023-05-02)


### Features

* **helm-charts:** bump to version 45 ([482f0d1](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/482f0d1a08a81aeaec55a43140c600001bdea2ad))

## [2.1.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v2.0.0...v2.1.0) (2023-04-27)


### Features

* **deep_merge:** add append list to deep merge ([#47](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/47)) ([7e39bf4](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/7e39bf41ab517b84cf6d23836a0b79e52fc15c4b))

## [2.0.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v1.0.0...v2.0.0) (2023-04-06)


### ⚠ BREAKING CHANGES

* **azure:** use managed identity to access object storage ([#42](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/42))

### Features

* **azure:** use managed identity to access object storage ([#42](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/42)) ([3c38035](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/3c380354f1596f30ace5e30da3fc5d787f9a31c6))

## [1.0.0](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v1.0.0-alpha.7...v1.0.0) (2023-03-24)


### Documentation

* add documentation structure and PR template ([#40](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/40)) ([7a20f46](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/7a20f460de5dd92ce71aa2b9b883defb67525471))

## [1.0.0-alpha.7](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v1.0.0-alpha.6...v1.0.0-alpha.7) (2023-02-22)


### Features

* **kind:** allow insecure access to storage endpoint ([#38](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/38)) ([6ba2f3a](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/6ba2f3a556f976905ca7ddd40b4aaaf0e87f5021))

## [1.0.0-alpha.6](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v1.0.0-alpha.5...v1.0.0-alpha.6) (2023-01-30)


### Miscellaneous Chores

* **chart:** bump version to 44 ([#34](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/34)) ([1446182](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/14461824506322d9963a71ee486eec9842ba3f16))

## [1.0.0-alpha.5](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v1.0.0-alpha.4...v1.0.0-alpha.5) (2023-01-30)


### Bug Fixes

* remove circular dependency between app and secret ([#32](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/32)) ([cb9f2d3](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/cb9f2d36a0696702a1190d98c997a92f28c15981))

## [1.0.0-alpha.4](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v1.0.0-alpha.3...v1.0.0-alpha.4) (2023-01-30)


### Features

* add variable to configure Argo CD auto sync ([#27](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/27)) ([214b798](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/214b798a7d54cc1476c72f4b01f9e7c4f96ac24e))

## [1.0.0-alpha.3](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v1.0.0-alpha.2...v1.0.0-alpha.3) (2022-12-27)


### Features

* **Azure:** add missing ID output ([#30](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/30)) ([29b3288](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/29b328842ac4fbbe672106ccdd5c423ead51aa24))

## [1.0.0-alpha.2](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/compare/v1.0.0-alpha.1...v1.0.0-alpha.2) (2022-12-21)


### ⚠ BREAKING CHANGES

* **azure:** delete useless resource group variable and clean up

### Features

* add kind variant and improve activation of thanos on all the variants ([#21](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/issues/21)) ([7f516ae](https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack/commit/7f516ae129ac9cf5dea994d3dece535ea8f3224a))


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
