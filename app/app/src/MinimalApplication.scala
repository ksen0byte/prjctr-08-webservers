package app

object MinimalApplication extends cask.MainRoutes {
  override def port: Int    = 8081
  override def host: String = "0.0.0.0"

  @cask.staticResources("/images/")
  def staticFileRoutes() = "images"

  initialize()
  println("ready to serve")
}
