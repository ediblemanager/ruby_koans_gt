# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutRegularExpressions < EdgeCase::Koan
  def test_a_pattern_is_a_regular_expression
    assert_equal Regexp, /pattern/.class
  end

  def test_a_regexp_can_search_a_string_for_matching_content
    assert_equal "match", "some matching content"[/match/]
  end

  def test_a_failed_match_returns_nil
    assert_equal nil, "some matching content"[/missing/]
  end

  # ------------------------------------------------------------------

	#The question mark is effectively saying "The character before me is optional",
	#You will get a result even if the character before the question mark isn't in the
	#pattern.
  def test_question_mark_means_optional
    assert_equal "ab", "abbcccddddeeeee"[/ab?/]
    assert_equal "a", "abbcccddddeeeee"[/az?/]
  end

  def test_plus_means_one_or_more
    assert_equal "bccc", "abbcccddddeeeee"[/bc+/]
  end

  def test_asterisk_means_zero_or_more
    assert_equal "abb", "abbcccddddeeeee"[/ab*/]
    assert_equal "a", "abbcccddddeeeee"[/az*/]
    assert_equal "", "abbcccddddeeeee"[/z*/]

    # THINK ABOUT IT:
    #
    # When would * fail to match?
		# Why does "abbcccddddeeeee"[/b*/] return ""...?
		# Why does "abbcccddddeeeee"[/ye*/] return nil...? Surely the 'e' should be 
		# caught?
		#
  end

  # THINK ABOUT IT:
  #
  # We say that the repetition operators above are "greedy."
  #
  # Why?
	#
	# They will return every match within a string? They aren't satisfied until 
	# they have found every match? Isn't that just gsub?
	# Or is it the opposite: it returns just the first match?
	#
	# en.wikibooks.org/wiki/Regular_Expressions/syntax - gives a nice answer.

  # ------------------------------------------------------------------

  def test_the_left_most_match_wins
    assert_equal "a", "abbccc az"[/az*/]
  end

  # ------------------------------------------------------------------

  def test_character_classes_give_options_for_a_character
    animals = ["cat", "bat", "rat", "zat"]
		#only match if the starting letter is contained within the square brackets.
		#so cat, bat, rat is good.
    assert_equal ["cat", "bat", "rat"], animals.select { |a| a[/[cbr]at/] }
  end

  def test_slash_d_iis_a_shortcut_for_a_digit_character_class
		#This is showing the \d will match a number in a string. Only the
		#first one though!
    assert_equal "42", "the number is 42"[/[0123456789]+/]
    assert_equal "42", "the number is 42"[/\d+/]
  end

  def test_character_classes_can_include_ranges
    assert_equal "42", "the number is 42"[/[0-9]+/]
  end

  def test_slash_s_is_a_shortcut_for_a_whitespace_character_class
		#This will match anything of a CLASS (class whitespace)
    assert_equal " \t\n", "space: \t\n"[/\s+/]
  end

  def test_slash_w_is_a_shortcut_for_a_word_character_class
    # NOTE:  This is more like how a programmer might define a word.
		# So [a-zA-Z0-9_] == \w in how it matches.
    assert_equal "variable_1", "variable_1 = 42"[/[a-zA-Z0-9_]+/]
    assert_equal "variable_1", "variable_1 = 42"[/\w+/]
  end

  def test_period_is_a_shortcut_for_any_non_newline_character
		#So does this mean that with the '.' it will continue on until it finds a newline?
		#Where is the specific "go until you find a newline" specified? - IMPLICIT
		# Does the presence of the full-stop mean that it bails and returns results when one is found?
    assert_equal "abc", "abc\n123"[/a.+/]
  end

  def test_a_character_class_can_be_negated
		#Hat symbol means "Starts with". So starts with number, find all which aren't numbers.
		#How does [/[^0-9]+/] differentiate from [/[0-9]+/] ?
		#^ means "starts with" and "don't bother about"?
    assert_equal "the number is ", "the number is 42"[/[^0-9]+/]
  end

  def test_shortcut_character_classes_are_negated_with_capitals
		#What is meant here is that the thing being searched for is ignored/not returned.
    assert_equal "the number is ", "the number is 42"[/\D+/]#Number not returned
    assert_equal "space:", "space: \t\n"[/\S+/]#Actual space characters, \t \n are not returned.
    assert_equal " = ", "variable_1 = 42"[/\W+/]#Return only the non "word" characters.
  end

  # ------------------------------------------------------------------

  def test_slash_a_anchors_to_the_start_of_the_string
		#only matches at the start of a string - so "start" works, but "end" doesn't
    assert_equal "start", "start end"[/\Astart/]
		assert_equal nil, "start end"[/\Aend/]
  end

  def test_slash_z_anchors_to_the_end_of_the_string
		#Because "start" is at the start, it won't be looking for it at the end of the string.
		assert_equal "end", "start end"[/end\z/]#End is actually at the end.
		assert_equal nil, "start end"[/start\z/]
  end

  def test_caret_anchors_to_the_start_of_lines
		#Does this take the 2 because the 2 is the only decimal at the start of a line?
    assert_equal "2", "num 42\n2 lines\n43 is great."[/^\d+/]
  end

  def test_dollar_sign_anchors_to_the_end_of_lines
		#Dollar sign means that it takes the last match?
		#Why is 2 ignored, but 42 taken?
    assert_equal "42", "2 lines\nnum 42\nseventy seven 77"[/\d+$/]
  end

  def test_slash_b_anchors_to_a_word_boundary
    assert_equal "vines", "bovine vines"[/\bvine./]
  end

  # ------------------------------------------------------------------

  def test_parentheses_group_contents
		#Pull out matching pattern.
		#Plus means pull out more than one.
    assert_equal "hahaha", "ahahaha"[/(ha)+/]
  end

  # ------------------------------------------------------------------

  def test_parentheses_also_capture_matched_content_by_number
    assert_equal "Gray", "Gray, James"[/(\w+), (\w+)/, 1]#Pull first word.
    assert_equal "James", "Gray, James"[/(\w+), (\w+)/, 2]#Pull only 2nd word.
  end

  def test_variables_can_also_be_used_to_access_captures
    assert_equal "Gray, James", "Name:  Gray, James"[/(\w+), (\w+)/]
    assert_equal "Gray", $1#ruby magic links it in to Gray
    assert_equal "James", $2#and likewise to James
  end

  # ------------------------------------------------------------------

  def test_a_vertical_pipe_means_or
    grays = /(James|Dana|Summer) Gray/
    assert_equal "James Gray", "James Gray"[grays]#He IS there!
    assert_equal "Summer", "Summer Gray"[grays, 1]#Takes first word from match
    assert_equal nil, "Jim Gray"[grays, 1]#no Jim please.
  end

  # THINK ABOUT IT:
  #
  # Explain the difference between a character class ([...]) and alternation (|).

  # ------------------------------------------------------------------

  def test_scan_is_like_find_all
		#Somehow this splits on the - with scan.
    assert_equal ["one", "two", "three"], "one two-three".scan(/\w+/)
  end

  def test_sub_is_like_find_and_replace
		#Nae idea at all.
    assert_equal "one t-three", "one two-three".sub(/(t\w*)/) { $1[0, 1] }
  end

  def test_gsub_is_like_find_and_replace_all
    assert_equal "one t-t", "one two-three".gsub(/(t\w*)/) { $1[0, 1] }
  end
end
