module ActiveAsari
  def self.amazon_safe_domain_name(domain)
    domain.underscore.sub /_/, '-' 
  end

  def self.aws_client
    AWS::CloudSearch::Client.new
  end

  def self.asari_domain_name(domain)
    amazon_domain = amazon_safe_domain_name domain
    domain_data = aws_client.describe_domains[:domain_status_list].select { |domain_data|  
      domain_data[:domain_name] == amazon_domain}
    domain_data.first[:search_service][:endpoint].split('.').first[7..-1]
  end

  def self.active_asari_search(domain, query)
    asari = Asari.new asari_domain_name(domain)
    fields = ACTIVE_ASARI_CONFIG[domain].map {|field| field.first.to_sym}
    asari.search query, :return_fields => fields
  end
end 
