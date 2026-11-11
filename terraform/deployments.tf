resource "kubernetes_deployment" "appwatch" {
    metadata {
        name = "appwatch-deployment"
        labels = {
            app = "appwatch"
        }
    }
    spec {
        replicas = 2

        selector {
            match_labels = {
                app = "appwatch"
            }
        }

        template {
            metadata {
                labels = {
                    app = "appwatch"
                }
            }

            spec {
                container {
                    image = "appwatch:latest"
                    image_pull_policy = "IfNotPresent"
                    name = "appwatch"

                    port {
                        container_port = 8080
                    }

                    security_context {
                        run_as_user = 10001
                        run_as_group = 10001
                        allow_privilege_escalation = false
                        read_only_root_filesystem = true
                        run_as_non_root = true
                    }

                    resources {
                        limits = {
                            cpu = "100m"
                            memory = "128Mi"
                        }
                        requests = {
                            cpu = "50m"
                            memory = "64Mi"
                        }
                    }
                    
                    startup_probe {
                        http_get {
                            path = "/health"
                            port = 8080
                        }
                        failure_threshold = 30
                        period_seconds = 5
                    }

                    liveness_probe {
                        http_get {
                            path = "/health"
                            port = 8080
                        }
                        failure_threshold = 5
                        period_seconds = 10
                    }

                    readiness_probe {
                        http_get {
                            path = "/ready"
                            port = 8080
                        }
                        initial_delay_seconds = 3
                        period_seconds = 5
                    }
                }
            }
        }
    }
}

resource "kubernetes_service" "appwatch" {
    metadata {
        name = "appwatch-service"
    }
    spec {
        selector = {
            app = kubernetes_deployment.appwatch.spec[0].template[0].metadata[0].labels.app
        }
        port {
            port = 80
            target_port = 8080
            node_port = 30080
        }
        type = "NodePort"
    }
}