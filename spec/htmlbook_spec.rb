# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../lib/nora_mark'
require File.dirname(__FILE__) + '/../lib/plugins/html_book'
require 'nokogiri'
require File.dirname(__FILE__) + '/nokogiri_test_helper.rb'

describe 'html_book plugin' do
  it 'generate body with data-book' do
    text = "---\ntitle: the title.\n---\ndocument."
    parsed = NoraMark::Document.parse(text, lang: 'ja')
    xhtml = parsed.to_html_book
    body = Nokogiri::XML::Document.parse(xhtml).root.at_xpath('xmlns:body')
    expect(body.selector_and_children)
      .to eq(
             ["body[data-type='book']",
              ['h1', 'the title.'],
              ['div.pgroup',
               ['p', 'document.']]]
             )
  end
  it 'generate chapter with section-content' do
    text = "---\ntitle: the title.\n---\n# section title\ndocument."
    parsed = NoraMark::Document.parse(text, lang: 'ja')
    xhtml = parsed.to_html_book
    body = Nokogiri::XML::Document.parse(xhtml).root.at_xpath('xmlns:body')    
    expect(body.selector_and_children)
      .to eq(
             ["body[data-type='book']",
              ['h1', 'the title.'],
              ["section[data-type='chapter']",
               ['h1', 'section title'],
               ['div.pgroup',
                ['p', 'document.']]]]
             )
  end
end
