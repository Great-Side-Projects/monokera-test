
at_exit do
  Rails.logger.info "[Sneakers] Deteniendo workers..."
  Sneakers.logger.info "Stopping Sneakers..."
  Sneakers::Worker #stop
end
