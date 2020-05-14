output application_cache_endpoint {
  value = aws_elasticache_cluster.application_cache.cache_nodes.0.address
}
