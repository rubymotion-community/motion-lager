class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    $log = Motion::Lager.new
    puts
    $log.log 'Color Options:'
    Motion::Lager::COLORS.each do |color, _|
      $log.log "#{color}", color
    end
    puts
    true
  end
end
