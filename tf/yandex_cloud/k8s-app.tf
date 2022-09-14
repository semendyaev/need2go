resource "yandex_serverless_container" "test-container" {
   name               = "test1"
   cores              = 1
   memory             = 128
   core_fraction      = 5     // 5% guatanteed perfomance (vCPU)
   execution_timeout  = "5s"
   service_account_id = var.provider_service_account_id
   image {
      url = "cr.yandex/crpbsek4co18hal5uolu/testgo:1"
   }
}