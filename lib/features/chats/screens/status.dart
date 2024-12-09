import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student_centric_app/features/chats/screens/chat_screen.dart';
import 'package:student_centric_app/features/home/bloc/home_bloc.dart';
import 'package:student_centric_app/features/home/models/get_status_model.dart';
import 'package:video_player/video_player.dart';

import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';

class StatusView extends StatelessWidget {
  const StatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        // if (state.is ) {
        //   return ErrorOutput(message: state.message);
        // }
        if (state.statusModel != null) {
          final status = state.statusModel!.data;

          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: status.length,
            itemBuilder: (context, index) {
              return _StatusAvatar(
                name: 'NATTy',
                imageUrl: 'assets/images/avatar.png',
                data: status[index],
              );
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

void showStatusDialog(BuildContext context, List<FileUpload> fileUploads) {
  showDialog(
    context: context,
    builder: (context) => StatusDialog(fileUploads: fileUploads),
  );
}

class _StatusAvatar extends StatelessWidget {
  final String name;
  final String imageUrl;
  final int statusCount;
  final StatusData data;
  // Number of status posts

  const _StatusAvatar(
      {required this.name,
      required this.imageUrl,
      this.statusCount = 1,
      required this.data});

  @override
  Widget build(BuildContext context) {
    double outerRadius = 30.r; // Increased from 28.r to 30.r
    double innerRadius = 23.r; // Decreased from 25.r to 23.r

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: InkWell(
        onTap: () {
          showStatusDialog(context, data.fileUploads);
        },
        child: Column(
          children: [
            SizedBox(
              width: outerRadius * 2,
              height: outerRadius * 2,
              child: CustomPaint(
                painter: StatusBorderPainter(
                  statusCount: statusCount,
                  color: AppColors.primaryColor,
                  strokeWidth: 3, // Match the strokeWidth here
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 24.r,
                    child: SvgPicture.asset(
                      AppAssets.profileIcon,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              name,
              style: TextStyle(fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusDialog extends StatefulWidget {
  final List<FileUpload> fileUploads;

  const StatusDialog({Key? key, required this.fileUploads}) : super(key: key);

  @override
  _StatusDialogState createState() => _StatusDialogState();
}

class _StatusDialogState extends State<StatusDialog> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    if (_currentIndex < widget.fileUploads.length &&
        widget.fileUploads[_currentIndex].fileType == 'image') {
      _timer = Timer(const Duration(seconds: 5), () {
        if (_currentIndex < widget.fileUploads.length - 1) {
          _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        }
      });
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _timer.cancel();
    _startAutoSlide();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      child: Column(
        children: [
          // Status Progress Indicator
          Row(
            children: widget.fileUploads.map((file) {
              int index = widget.fileUploads.indexOf(file);
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 5,
                  decoration: BoxDecoration(
                    color: index <= _currentIndex
                        ? Colors.blue
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }).toList(),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.fileUploads.length,
              itemBuilder: (context, index) {
                final file = widget.fileUploads[index];
                if (file.fileType == 'video') {
                  return VideoWidget(
                    url: file.secureUrl,
                    onVideoFinished: () {
                      if (_currentIndex < widget.fileUploads.length - 1) {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    },
                  );
                } else {
                  return Image.network(
                    file.secureUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Text("Image could not load."),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String url;
  final VoidCallback onVideoFinished;

  const VideoWidget(
      {Key? key, required this.url, required this.onVideoFinished})
      : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {}); // Refresh when video is initialized
        _controller.setLooping(false); // Don't loop the video
        _controller.setVolume(1.0); // Ensure sound is enabled
        _controller.play();

        _controller.addListener(() {
          if (_controller.value.isInitialized &&
              !_controller.value.isPlaying &&
              _controller.value.position == _controller.value.duration) {
            widget.onVideoFinished(); // Notify when video finishes
          }
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
