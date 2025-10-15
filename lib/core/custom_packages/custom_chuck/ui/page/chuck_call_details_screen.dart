import 'package:flutter/material.dart';

import '../../core/chuck_core.dart';
import '../../model/chuck_http_call.dart';
import '../../ui/widget/chuck_call_error_widget.dart';
import '../../ui/widget/chuck_call_overview_widget.dart';
import '../../ui/widget/chuck_call_request_widget.dart';
import '../../ui/widget/chuck_call_response_preview_widget.dart';
import '../../ui/widget/chuck_call_response_widget.dart';
import '../../utils/chuck_constants.dart';

class ChuckCallDetailsScreen extends StatefulWidget {
  final ChuckHttpCall call;
  final ChuckCore core;

  const ChuckCallDetailsScreen(
    this.call,
    this.core, {
    super.key,
  });

  @override
  State<ChuckCallDetailsScreen> createState() => _ChuckCallDetailsScreenState();
}

class _ChuckCallDetailsScreenState extends State<ChuckCallDetailsScreen> with SingleTickerProviderStateMixin {
  ChuckHttpCall get call => widget.call;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.core.directionality ?? Directionality.of(context),
      child: StreamBuilder<List<ChuckHttpCall>>(
        stream: widget.core.callsSubject,
        initialData: [widget.call],
        builder: (context, callsSnapshot) {
          if (callsSnapshot.hasData) {
            final ChuckHttpCall? call =
            callsSnapshot.data!.firstWhere((snapshotCall) => snapshotCall.id == widget.call.id);
            if (call != null) {
              return _buildMainWidget();
            } else {
              return _buildErrorWidget();
            }
          } else {
            return _buildErrorWidget();
          }
        },
      ),
    );
  }

  Widget _buildMainWidget() => DefaultTabController(
        initialIndex: 1,
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            bottom: TabBar(
              indicatorColor: ChuckConstants.lightRed,
              tabs: const [
                Tab(icon: Icon(Icons.info_outline), text: 'Overview'),
                Tab(icon: Icon(Icons.arrow_upward), text: 'Request'),
                Tab(icon: Icon(Icons.arrow_downward), text: 'Response'),
                Tab(icon: Icon(Icons.preview), text: 'Preview'),
                Tab(icon: Icon(Icons.warning), text: 'Error'),
              ],
            ),
            // title: const Text('Chuck - HTTP Call Details'),
            title: Text(call.endpoint, style: const TextStyle(fontSize: 16)),
          ),
          body: TabBarView(
            children: [
              ChuckCallOverviewWidget(call),
              ChuckCallRequestWidget(call),
              ChuckCallResponseWidget(call),
              ChuckCallResponsePreviewWidget(call),
              ChuckCallErrorWidget(call),
            ],
          ),
        ),
      );

  Widget _buildErrorWidget() => const Center(child: Text('Failed to load data'));
}
