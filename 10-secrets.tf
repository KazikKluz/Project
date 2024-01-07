resource "kubernetes_secret" "jwt_secret" {
  metadata {
    name      = "jwt-secret"
    namespace = "default"
  }

  data = {
    JWT_KEY = "asdfasd0f8as089df7"
  }

  type = "Opaque"
}

resource "kubernetes_secret" "stripe_secret" {
  metadata {
    name      = "stripe-secret"
    namespace = "default"
  }

  data = {
    STRIPE_KEY = "sk_test_51GvoSoAJujcbjWBpTwvNoED6KDw5tDhzz7XoVWnCuOk9iSG98idT4PUqbywrryfBDJANzBnXBqMqxtq29BFPXdXq00HFP4maon"
  }

  type = "Opaque"
}

