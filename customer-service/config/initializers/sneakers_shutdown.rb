
at_exit do
  Rails.logger.info "[Sneakers] Deteniendo workers..."
  Sneakers.logger.info "Stopping Sneakers..."
  Sneakers::Worker #stop all workers
  Sneakers.logger.info "All Sneakers workers stopped."
  Rails.logger.info "[Sneakers] Workers detenidos."
end
