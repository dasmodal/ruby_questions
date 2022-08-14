require 'nokogiri'
require 'open-uri'

module Parser
  def self.parse_questions(url)
    doc = Nokogiri::HTML(URI.open(url))

    category = url.scan(/[A-Za-z]*.md/).join.delete('.md')
    questions =
      doc.css('div.readme li').map do |elem|
        question = elem.css('p').first&.text
        next if question.nil?

        answer = elem.css('details').text.strip.gsub("Ответ\n", '')

        { question: question, answer: answer, category: category }
      end

    questions.compact!.each do |question|
      Question.create(cat: question[:category],
        question: question[:question],
        answer: question[:answer]
      )
    end
  end
end
