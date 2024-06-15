# stamp-iot-eks

#### 前提
* 以下を作業PCにインストールしていること
  * aws
  * terraform
* 適切なIAMロールを持ったAWSアカウントで `aws configure` を実行済みであること

#### 手順
* `terraform plan`
* `terraform apply`
* `aws eks update-kubeconfig --name <クラスター名>--region <リージョン>`
  * kubeconfig が更新される
* `kubectl get pods -A` などを実行できることを確認する