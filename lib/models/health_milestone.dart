class HealthMilestone {
  final String title;
  final String description;
  final Duration requiredDuration;

  const HealthMilestone({
    required this.title,
    required this.description,
    required this.requiredDuration,
  });
}

const List<HealthMilestone> healthMilestones = [
  HealthMilestone(
    title: '20 минут',
    description: 'Приходят в норму пульс и артериальное давление, улучшается кровообращение.',
    requiredDuration: Duration(minutes: 20),
  ),
  HealthMilestone(
    title: '12 часов',
    description: 'Уровень угарного газа в крови падает до нормы, количество кислорода возрастает.',
    requiredDuration: Duration(hours: 12),
  ),
  HealthMilestone(
    title: '24 часа',
    description: 'Снижается риск острого инфаркта миокарда.',
    requiredDuration: Duration(hours: 24),
  ),
  HealthMilestone(
    title: '48 часов',
    description: 'Из организма полностью выводится никотин, начинают восстанавливаться поврежденные рецепторы вкуса и обоняния.',
    requiredDuration: Duration(hours: 48),
  ),
  HealthMilestone(
    title: '72 часа',
    description: 'Дышать становится легче, расслабляются бронхиальные мышцы, энергетический уровень начинает расти.',
    requiredDuration: Duration(hours: 72),
  ),
  HealthMilestone(
    title: '3 недели',
    description: 'Проходит физический абстинентный синдром («ломка»), заметно улучшается общая выносливость.',
    requiredDuration: Duration(days: 21),
  ),
  HealthMilestone(
    title: '3 месяца',
    description: 'Уменьшаются одышка и «кашель курильщика». Активно восстанавливаются микроскопические реснички бронхов.',
    requiredDuration: Duration(days: 90),
  ),
  HealthMilestone(
    title: '1 год',
    description: 'Риск развития ишемической болезни сердца снижается ровно в два раза.',
    requiredDuration: Duration(days: 365),
  ),
  HealthMilestone(
    title: '5 лет',
    description: 'Риск инсульта снижается до уровня человека, который никогда не курил.',
    requiredDuration: Duration(days: 365 * 5),
  ),
  HealthMilestone(
    title: '10 лет',
    description: 'Риск заболеть раком легких сокращается примерно в два раза по сравнению с курильщиками.',
    requiredDuration: Duration(days: 365 * 10),
  ),
  HealthMilestone(
    title: '15 лет',
    description: 'Риск развития тяжелых сердечных заболеваний падает до показателей некурящего.',
    requiredDuration: Duration(days: 365 * 15),
  ),
];
