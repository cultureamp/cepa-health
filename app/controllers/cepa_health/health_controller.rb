module CepaHealth
  class HealthController < ActionController::Base
    before_action :check_key

    def check
      @result = CepaHealth.execute(only: params[:only], except: params[:except])

      status = @result.success? ? 200 : 500

      respond_to do |format|
        format.html { render status: status }
        format.json do
          records = @result.records.map do |name, status, comment|
            { name: name, status: status, comment: comment }
          end
          render json: records, status: status
        end
      end
    end

    private

    def check_key
      head 404 unless params[:key] == CepaHealth.key
    end
  end
end
