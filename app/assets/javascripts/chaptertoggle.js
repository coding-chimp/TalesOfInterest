$(document).ready(function(){
	$(".show").click(function(){
	  $(".chapterlist").show();
	  $(".hide").show();
	  $(".show").hide();
	});

	$(".hide").click(function(){
	  $(".chapterlist").hide();
	  $(".hide").hide();
	  $(".show").show();
	});
})