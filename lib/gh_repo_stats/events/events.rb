module GHRepo
  class RepoEvent < Event
    attribute(:repository, aliases: [:repo]) do |rep|
      Repository.from_hash(rep) if rep
    end
  end

  class PushEvent < RepoEvent
    tag('push')
  end

  class CommitCommentEvent < RepoEvent
    tag('commit-comment')
  end

  class CreateEvent < RepoEvent
    tag('create')
  end

  class DeleteEvent < RepoEvent
    tag('delete')
  end

  class DeploymentEvent < RepoEvent
    tag('deployment')
  end

  class DownloadEvent < RepoEvent
    tag('download')
  end

  class DeploymentStatusEvent < RepoEvent
    tag(reformat('DeploymentStatusEvent'))
  end

  class FollowEvent < Event
    tag(reformat('FollowEvent'))
  end

  class ForkEvent < RepoEvent
    tag(reformat('ForkEvent'))
  end

  class ForkApplyEvent < RepoEvent
    tag(reformat('ForkApplyEvent'))
  end

  class GistEvent < Event
    tag(reformat('GistEvent'))
  end

  class GollumEvent < RepoEvent
    tag(reformat('GollumEvent'))
  end

  class IssueCommentEvent < RepoEvent
    tag(reformat('IssueCommentEvent'))
  end

  class IssuesEvent < RepoEvent
    tag(reformat('IssuesEvent'))
  end

  class LabelEvent < RepoEvent
    tag(reformat('LabelEvent'))
  end

  class MemberEvent < RepoEvent
    tag(reformat('MemberEvent'))
  end

  class MembershipEvent < RepoEvent
    tag(reformat('MembershipEvent'))
  end

  class MilestoneEvent < RepoEvent
    tag(reformat('MilestoneEvent'))
  end

  class OrganizationEvent < RepoEvent
    tag(reformat('OrganizationEvent'))
  end

  class OrgBlockEvent < RepoEvent
    tag(reformat('OrgBlockEvent'))
  end

  class PageBuildEvent < RepoEvent
    tag(reformat('PageBuildEvent'))
  end

  class ProjectCardEvent < RepoEvent
    tag(reformat('ProjectCardEvent'))
  end

  class ProjectColumnEvent < RepoEvent
    tag(reformat('ProjectColumnEvent'))
  end

  class ProjectEvent < RepoEvent
    tag(reformat('ProjectEvent'))
  end

  class PublicEvent < RepoEvent
    tag(reformat('PublicEvent'))
  end

  class PullRequestEvent < RepoEvent
    tag(reformat('PullRequestEvent'))
  end

  class PullRequestReviewEvent < RepoEvent
    tag(reformat('PullRequestReviewEvent'))
  end

  class PullRequestReviewCommentEvent < RepoEvent
    tag(reformat('PullRequestReviewCommentEvent'))
  end

  class ReleaseEvent < RepoEvent
    tag(reformat('ReleaseEvent'))
  end

  class RepositoryEvent < RepoEvent
    tag(reformat('RepositoryEvent'))
  end

  class StatusEvent < RepoEvent
    tag(reformat('StatusEvent'))
  end

  class TeamEvent < RepoEvent
    tag(reformat('TeamEvent'))
  end

  class TeamAddEvent < RepoEvent
    tag(reformat('TeamAddEvent'))
  end

  class WatchEvent < RepoEvent
    tag(reformat('WatchEvent'))
  end
end
