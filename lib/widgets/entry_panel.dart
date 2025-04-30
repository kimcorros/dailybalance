import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EntryPanel extends StatefulWidget {
  const EntryPanel({
    required this.title,
    required this.entryList,
    required this.bg,
    required this.fg,
    required this.onChanged,
    super.key,
  });
  final String title;
  final List<String> entryList;
  final Color bg, fg;
  final ValueChanged<List<String>> onChanged;

  @override
  State<EntryPanel> createState() => _EntryPanelState();
}

class _EntryPanelState extends State<EntryPanel> {
  final _controller = TextEditingController();

  // ─── 1.  Call this from the plus-button ─────────────────────────
  void _openAddDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: widget.bg,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Title ──────────────────────────────────────────
                Text(
                  'Add ${widget.title.toLowerCase()} item',
                  style: TextStyle(
                    color: widget.fg,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // ── Textarea ───────────────────────────────────────
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                  autofocus: true,
                  style: TextStyle(color: widget.fg, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Type here…',
                    hintStyle: TextStyle(color: widget.fg.withOpacity(.6)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: widget.fg.withOpacity(.4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: widget.fg, width: 2),
                    ),
                  ),
                  onSubmitted: (_) => _submit(ctx),
                ),

                const SizedBox(height: 24),

                // ── Buttons row ────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel (bottom-left)
                    SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: widget.fg,
                          side: BorderSide(color: widget.fg),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          _controller.clear();
                          Navigator.pop(ctx);
                        },
                        child: const Text('CANCEL'),
                      ),
                    ),

                    // Add (bottom-right)
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.fg,
                          foregroundColor: widget.bg,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _submit(ctx),
                        child: const Text('ADD'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── 2.  Commit & close ─────────────────────────────────────────
  void _submit(BuildContext ctx) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      widget.entryList.add(text);
      widget.onChanged(widget.entryList);
    });
    _controller.clear();
    Navigator.pop(ctx); // close the centered dialog
  }

  void _add() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      widget.entryList.add(text);
      widget.onChanged(widget.entryList);
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.bg,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
            child: Text(
              widget.title,
              style: TextStyle(
                color: widget.fg,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ), // keeps bullets off edge
              itemCount: widget.entryList.length,
              itemBuilder:
                  (_, i) => Dismissible(
                    key: ValueKey('${widget.title}-$i'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      setState(() {
                        widget.entryList.removeAt(i);
                        widget.onChanged(widget.entryList);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ─── SVG bullet ─────────────────────────────────────────
                          SvgPicture.asset(
                            widget.title == 'GOOD'
                                ? 'assets/icons/check.svg'
                                : 'assets/icons/x.svg',
                            width: 18,
                            height: 24,
                            color:
                                widget.title == 'GOOD'
                                    ? Colors.green[600]
                                    : Colors.red[600],
                          ),
                          const SizedBox(width: 8),

                          // ─── Text ───────────────────────────────────────────────
                          Expanded(
                            child: Text(
                              widget.entryList[i],
                              style: TextStyle(fontSize: 18, color: widget.fg),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => _openAddDialog(context),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color:
                        widget.title == 'GOOD'
                            ? Colors.black
                            : Colors.white, // green or red for quick affordance
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.add,
                    color: widget.title == 'GOOD' ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
