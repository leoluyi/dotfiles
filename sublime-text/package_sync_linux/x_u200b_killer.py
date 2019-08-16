import sublime, sublime_plugin

class ShowU200b(sublime_plugin.EventListener):
    def on_modified_async(self, view):
        u200b_regions = view.find_all('\u200b')
        if len(u200b_regions) > 0:
            view.add_regions("u200b_regions", u200b_regions, "string", "circle")
            view.show_popup('U200B Detected!!!')
        else:
            view.erase_regions("u200b_regions")


class RemoveU200b(sublime_plugin.TextCommand):
    def run(self, edit):
        print('Removing U200B')

        regions = self.view.find_all('\u200b')
        for r in reversed(regions):
            self.view.erase(edit, r)

