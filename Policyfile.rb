# frozen_string_literal: true

name 'gpg'

run_list 'test::default'

cookbook 'gpg', path: '.'
cookbook 'yum-epel', git: 'https://github.com/sous-chefs/yum-epel.git', branch: 'main'
cookbook 'test', path: './test/fixtures/cookbooks/test'

Dir.children('./test/fixtures/cookbooks/test/recipes').grep(/\.rb\z/).sort.each do |recipe|
  recipe_name = File.basename(recipe, '.rb')

  named_run_list recipe_name.to_sym, 'test::' + recipe_name
end
