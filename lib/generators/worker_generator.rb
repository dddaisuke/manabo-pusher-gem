class UploaderGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)

  def create_uploader_file
    template "worker.rb", File.join('app/workers', class_path, 'pusher_log_worker.rb')
  end
end
