class OnBoardingContent {
  String image;
  String title;
  String description;
  OnBoardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnBoardingContent> contents = [
  OnBoardingContent(
    image: "assets/screen1.jpg",
    title: "Track Your Expenses\nEffortlessly",
    description: "Monitor your daily spending\nwith real-time insights",
  ),
  OnBoardingContent(
    image: "assets/screen2.jpg",
    title: "Set Budgets & Save More",
    description: "Plan your finances wisely\nand achieve your goals faster",
  ),
  OnBoardingContent(
    image: "assets/screen3.jpg",
    title: "Smart Reports & Analytics",
    description: "Get detailed expense breakdowns\nand take control of your money",
  ),
];
