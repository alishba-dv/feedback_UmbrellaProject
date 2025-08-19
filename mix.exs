defmodule FeedbackUmbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
#      {:phoenix_swagger, "~> 0.8.3"}, # swagger generator + macros
#      {:ex_json_schema, "~> 0.7.1"},   # json schema support (used by phoenix_swagger)
#      {:poison, "~> 2.2"}             #optional
    ]
  end
end
