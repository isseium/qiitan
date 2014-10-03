class Api::ApiController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  before_filter :allow_cross_domain_access
  rescue_from Exception, with: :handle_error
  skip_before_filter :verify_authenticity_token
  
  # エラークラスとエラーコードのマッピング
  @@exception_to_code = {
    # ActiveRecord 関連
    'ActiveRecord::RecordInvalid'         => {code: 40000},
    'is too short'                        => {code: 40001},
    'is too long'                         => {code: 40002},
    'is wrong length'                     => {code: 40003},
    'has already been taken'              => {code: 40004},   # ユニーク
    'can\'t be blank'                     => {code: 40005},
    'is invalid'                          => {code: 40006},   # 無効な値が指定されている
    'is empty'                            => {code: 40007},   # 空 (precense)
    
    # 独自定義
    'User not found'                      => {code: 40100},
    'Could not update user'               => {code: 40101},
    
    'ActionController::ParameterMissing'  => {code: 40200},
    
    # 開発時エラー
    'ActionView::MissingTemplate'         => {code: 90000},
  }
  
  
  private 
  def retrieve_errorno_by_message message
    begin
      {
        message: message,
        code: @@exception_to_code[message][:code]
      }
    rescue
      {
        message: message,
        code: nil
      }
    end
  end
  
  def handle_error exception
    error_responses = []
    
    case exception
    when ActiveRecord::RecordInvalid
      exception.record.errors.each do |attribute, error|
        error_response = retrieve_errorno_by_message(error)
        error_response[:message] = attribute.to_s + " " + error
        error_responses.push(error_response)
      end
    when RuntimeError
      error_responses.push(retrieve_errorno_by_message(exception.message))
    else
      error_responses.push(retrieve_errorno_by_message(exception.class.to_s))
    end
    
    render json: error_responses, status: 500
  end
  
  # クロスドメイン対策
  def allow_cross_domain_access
    # response.headers["Access-Control-Allow-Origin"] = Settings.endpoint.frontend
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"
    response.headers["Access-Control-Allow-Methods"] = "PUT,DELETE,POST,GET,OPTIONS"
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    response.headers['X-Frame-Options'] = 'ALLOW-FROM https://apps.facebook.com'
  end
end
