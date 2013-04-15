xml.instruct! :xml, version: "1.0"
xml.urlset "xmlns" => 
"http://www.sitemaps.org/schemas/sitemap/0.9" do
	for episode in @episodes do
		xml.url do
			xml.loc episode_url(episode.podcast, episode)
			xml.lastmod episode.updated_at.to_date
			xml.changefreq "monthly"
			xml.priority "0.5"
		end
	end
end