import '../../data/local/enums.dart';

extension TradeDirectionLabel on TradeDirection {
  String get label => switch (this) {
        TradeDirection.buy => 'Buy',
        TradeDirection.sell => 'Sell',
      };
}

extension TradeStatusLabel on TradeStatus {
  String get label => switch (this) {
        TradeStatus.open => 'Open',
        TradeStatus.closedTp => 'Closed TP',
        TradeStatus.closedSl => 'Closed SL',
        TradeStatus.closedManual => 'Closed Manual',
      };
}

extension EmotionStateLabel on EmotionState {
  String get label => switch (this) {
        EmotionState.calm => 'Tenang',
        EmotionState.doubtful => 'Ragu',
        EmotionState.fomo => 'FOMO',
        EmotionState.greedy => 'Serakah',
        EmotionState.disciplined => 'Disiplin',
        EmotionState.tilt => 'Tilt',
        EmotionState.other => 'Lainnya',
      };
}
