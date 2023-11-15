module Teryt
  class Client
    attr_reader :savon_client

    def initialize(username:, password:)
      @savon_client = Savon.client(
        wsdl: WSDL,
        wsse_auth: [username, password],
        use_wsa_headers: true,
      )
    end

    def czy_zalogowany
      savon_client.call(:czy_zalogowany, message: {})
    end

    def pobierz_date_aktualnego_kat_ulic
      savon_client.call(:pobierz_date_aktualnego_kat_ulic)
    end

    def pobierz_liste_wojewodztw(data_stanu: Date.today)
      savon_client
        .call(:pobierz_liste_wojewodztw, message: { "tns:DataStanu" => data_stanu })
        .to_hash
        .dig(:pobierz_liste_wojewodztw_response, :pobierz_liste_wojewodztw_result, :jednostka_terytorialna)
        .map { |attrs| JednostkaTerytorialna.new(**attrs) }
    end

    def pobierz_liste_powiatow(woj: "", data_stanu: Date.today)
      savon_client.call(:pobierz_liste_powiatow, message: { "tns:DataStanu" => data_stanu })
    end
  end
end